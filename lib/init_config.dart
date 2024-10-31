import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/refresh_token_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/token_data_entity.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';
import 'package:project_vehicle_log_app/support/app_connectivity_service.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_local_storage.dart';
import 'package:project_vehicle_log_app/support/app_logger.dart';

class AppInitConfig {
  static late AppApiService appApiService;
  static TokenDataEntity? tokenDataEntity;
  static List<Function> _onRefreshQueue = [];
  static bool _isRefreshing = false;

  static dio.Response? refreshTokenResponse;

  static List<Function> refreshQueue = [];
  static List<Function> _refreshQueue = [];

  final List<Completer<Response>> _refreshCompleters = [];

  static Future<void> init() async {
    // AppTheme.appThemeInit();
    await GetStorage.init();
    await AppInfo.appInfoInit();
    await AppConnectivityService.init();
    await AppLocalStorage.init();

    // EnvironmentConfig.customBaseUrl = "https://4be5-112-215-170-211.ngrok.io"; // for ngrok
    EnvironmentConfig.customBaseUrl = "https://e88e-114-10-42-189.ngrok-free.app"; // for ngrok
    // EnvironmentConfig.customBaseUrl = "http://10.0.2.2:8080"; // for emulator android
    // EnvironmentConfig.customBaseUrl = "http://localhost:8080"; // for emulator iOS

    await interceptorsLogic2();
    // await interceptorsLogic();
    // await interceptorsLogicOld();
  }

  static Future<void> interceptorsLogic2() async {
    tokenDataEntity = await AccountLocalRepository().getDataToken();

    appApiService = AppApiService(EnvironmentConfig.baseUrl());

    TokenDataEntity? localTokenDataEntity;

    appApiService.dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Retrieve the latest token data before each request
          var tokenDataEntity = await AccountLocalRepository().getDataToken();
          options.headers["token"] = tokenDataEntity?.accessToken;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          var response = error.response;
          var tokenDataEntity = await AccountLocalRepository().getDataToken();

          if (response == null) return handler.next(error);

          if (response.realUri.path != AppApiPath.refreshToken && response.statusCode == 401) {
            if (_isRefreshing) {
              // Queue the requests while refreshing
              _refreshQueue.add(() async {
                final response = await _retryRequest(error.requestOptions);
                handler.resolve(response);
              });
              return;
            }

            _isRefreshing = true;

            try {
              AppAccountReposistory accountReposistory = AppAccountReposistory(appApiService);
              AppLogger.debugLog("tokenDataEntity!.refreshToken!: ${tokenDataEntity!.refreshToken!}");
              AppLogger.debugLog("tokenDataEntity!.accessToken!: ${tokenDataEntity.accessToken!}");
              RefreshTokenResponseModel? result = await accountReposistory.refreshToken(
                refreshToken: tokenDataEntity.refreshToken!,
                token: tokenDataEntity.accessToken!,
              );
              if (result!.data != null) {
                localTokenDataEntity = TokenDataEntity(
                  accessToken: result.data!.accessToken,
                  accessTokenExpiryTime: result.data!.accessTokenExpiryTime,
                  refreshToken: result.data!.refreshToken,
                  refreshTokenExpiryTime: result.data!.refreshTokenExpiryTime,
                );
                tokenDataEntity = localTokenDataEntity;
                await AccountLocalRepository().setRefreshToken(data: localTokenDataEntity!.refreshToken!);
                await AccountLocalRepository().setUserToken(data: localTokenDataEntity!.accessToken!);
                await AccountLocalRepository().setDataToken(data: localTokenDataEntity!);
              }

              // Retry all queued requests with the new token
              for (var request in _refreshQueue) {
                await request();
              }
              _refreshQueue.clear();

              // Retry the original failed request
              final response = await _retryRequest(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              // Clear token data and sign the user out on refresh failure
              // await AccountLocalRepository().clearTokensAndSignOut();

              await AccountLocalRepository().removeLocalAccountData();
              await AccountLocalRepository().removeRefreshToken();
              await AccountLocalRepository().removeUserToken();
              await AccountLocalRepository().removeDataToken();
              await AccountLocalRepository().setIsSignOut();
              await VehicleLocalRepository().removeLocalVehicleDataV2();
              Get.offAll(() => const SignInPage());
              return handler.reject(error);
            } finally {
              _isRefreshing = false;
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  static Future<void> interceptorsLogic() async {
    tokenDataEntity = await AccountLocalRepository().getDataToken();

    appApiService = AppApiService(EnvironmentConfig.baseUrl());

    TokenDataEntity? localTokenDataEntity;

    appApiService.dio.interceptors.add(
      dio.InterceptorsWrapper(
        // onRequest: (options, handler) async {
        //   tokenDataEntity = await AccountLocalRepository().getDataToken();
        //   options.headers["token"] = "${tokenDataEntity?.accessToken}";
        //   return handler.next(options);
        // },
        // onResponse: (response, handler) {
        //   return handler.next(response);
        // },
        onError: (error, handler) async {
          var response = error.response;
          if (response == null) {
            return handler.next(error);
          }

          if ((response.realUri.path == AppApiPath.signUpAccount || response.realUri.path == AppApiPath.signInAccount || response.realUri.path == AppApiPath.refreshToken) &&
              response.statusCode != 401 &&
              response.data['message'] != "expired") {
            return handler.next(error);
          }

          if (!response.realUri.path.contains("/account/userdata") &&
              !response.realUri.path.contains("/account/editprofile") &&
              !response.realUri.path.contains("/vehicle") &&
              !response.realUri.path.contains("/notifications")) {
            return handler.next(error);
          }

          if (tokenDataEntity == null && tokenDataEntity?.accessToken == null && tokenDataEntity?.refreshToken == null) {
            return handler.next(error);
          }

          if (_isRefreshing) {
            // Queue the requests while refreshing
            refreshQueue.add(() async {
              final response = await _retryRequest(error.requestOptions);
              handler.resolve(response);
            });
            // handler.resolve(response);
            return;
          }

          AppAccountReposistory accountReposistory = AppAccountReposistory(appApiService);
          AppLogger.debugLog("tokenDataEntity!.refreshToken!: ${tokenDataEntity!.refreshToken!}");
          AppLogger.debugLog("tokenDataEntity!.accessToken!: ${tokenDataEntity!.accessToken!}");
          RefreshTokenResponseModel? result = await accountReposistory.refreshToken(
            refreshToken: tokenDataEntity!.refreshToken!,
            token: tokenDataEntity!.accessToken!,
          );

          _isRefreshing = true;

          if (result == null || result.data == null) {
            refreshQueue.clear();
            _isRefreshing = false;
            tokenDataEntity = null;

            await AccountLocalRepository().removeLocalAccountData();
            await AccountLocalRepository().removeRefreshToken();
            await AccountLocalRepository().removeUserToken();
            await AccountLocalRepository().removeDataToken();
            await AccountLocalRepository().setIsSignOut();
            await VehicleLocalRepository().removeLocalVehicleDataV2();
            Get.offAll(() => const SignInPage());
            return handler.next(error);
          }

          if (result.data != null) {
            localTokenDataEntity = TokenDataEntity(
              accessToken: result.data!.accessToken,
              accessTokenExpiryTime: result.data!.accessTokenExpiryTime,
              refreshToken: result.data!.refreshToken,
              refreshTokenExpiryTime: result.data!.refreshTokenExpiryTime,
            );
            tokenDataEntity = localTokenDataEntity;
            await AccountLocalRepository().setRefreshToken(data: localTokenDataEntity!.refreshToken!);
            await AccountLocalRepository().setUserToken(data: localTokenDataEntity!.accessToken!);
            await AccountLocalRepository().setDataToken(data: localTokenDataEntity!);

            AppLogger.debugLog("response.requestOptions.uri.toString(): ${response.requestOptions.uri.toString()}");
            AppLogger.debugLog("method: ${MethodRequest.values.firstWhere(
              (element) {
                return response.requestOptions.method.toLowerCase() == element.name.toLowerCase();
              },
            )}");
            AppLogger.debugLog("tokenDataEntity!.accessToken!0: ${tokenDataEntity!.accessToken!}");

            for (var callback in refreshQueue) {
              callback();
            }
            refreshQueue.clear();

            final response1 = await _retryRequest(error.requestOptions);

            dio.Response output = await AppApiService(EnvironmentConfig.baseUrl()).call(
              response.requestOptions.uri.toString(),
              method: MethodRequest.values.firstWhere(
                (element) {
                  return response.requestOptions.method.toLowerCase() == element.name.toLowerCase();
                },
              ),
              request: response.requestOptions.data,
              header: {
                'token': tokenDataEntity!.accessToken!,
              },
            );
            // AppLogger.debugLog("output $output");
            return handler.resolve(response1);
            // return handler.resolve(output);
          }

          _isRefreshing = false;

          // return handler.next(error);
        },
      ),
    );
  }

  static Future<void> interceptorsLogicOld() async {
    tokenDataEntity = await AccountLocalRepository().getDataToken();

    appApiService = AppApiService(EnvironmentConfig.baseUrl());

    TokenDataEntity? localTokenDataEntity;

    appApiService.dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          tokenDataEntity = await AccountLocalRepository().getDataToken();
          options.headers["token"] = "${tokenDataEntity?.accessToken}";
          return handler.next(options);
        },
        onResponse: (response, handler) {
          refreshTokenResponse = response;
          return handler.next(response);
        },
        onError: (error, handler) async {
          tokenDataEntity = await AccountLocalRepository().getDataToken();
          AppLogger.debugLog("tokenDataEntity: ${tokenDataEntity?.toJson()}");
          var response = error.response;
          if (response == null) {
            return handler.next(error);
          }
          AppLogger.debugLog("_isRefreshing: $_isRefreshing");

          if (response.realUri.path != AppApiPath.signUpAccount &&
              response.realUri.path != AppApiPath.signInAccount &&
              response.realUri.path != AppApiPath.refreshToken &&
              response.statusCode == 401 &&
              response.data['message'] == "expired") {
            if (_isRefreshing) {
              // Queue the requests while refreshing
              refreshQueue.add(() async {
                final response = await _retryRequest(error.requestOptions);
                handler.resolve(response);
              });
              // handler.resolve(response);
              return;
            }
            _isRefreshing = true;

            if (response.realUri.path.contains("/account/userdata") ||
                response.realUri.path.contains("/account/editprofile") ||
                response.realUri.path.startsWith("/vehicle") ||
                response.realUri.path.startsWith("/notifications")) {
              if (tokenDataEntity != null && tokenDataEntity?.accessToken != null && tokenDataEntity?.refreshToken != null) {
                AppAccountReposistory accountReposistory = AppAccountReposistory(appApiService);
                RefreshTokenResponseModel? result = await accountReposistory.refreshToken(
                  refreshToken: tokenDataEntity!.refreshToken!,
                  token: tokenDataEntity!.accessToken!,
                );
                if (result != null && result.data != null) {
                  await AccountLocalRepository().setRefreshToken(data: result.data!.refreshToken!);
                  await AccountLocalRepository().setUserToken(data: result.data!.accessToken!);
                  localTokenDataEntity = TokenDataEntity(
                    accessToken: result.data!.accessToken,
                    accessTokenExpiryTime: result.data!.accessTokenExpiryTime,
                    refreshToken: result.data!.refreshToken,
                    refreshTokenExpiryTime: result.data!.refreshTokenExpiryTime,
                  );
                  await AccountLocalRepository().setDataToken(data: localTokenDataEntity!);

                  tokenDataEntity = await AccountLocalRepository().getDataToken();

                  AppLogger.debugLog("response.requestOptions.uri.toString(): ${response.requestOptions.uri.toString()}");
                  AppLogger.debugLog("method: ${MethodRequest.values.firstWhere(
                    (element) {
                      return response.requestOptions.method.toLowerCase() == element.name.toLowerCase();
                    },
                  )}");
                  AppLogger.debugLog("tokenDataEntity!.accessToken!: ${tokenDataEntity!.accessToken!}");

                  _isRefreshing = false;
                  refreshQueue.clear();

                  dio.Response output = await AppApiService(EnvironmentConfig.baseUrl()).call(
                    response.requestOptions.uri.toString(),
                    method: MethodRequest.values.firstWhere(
                      (element) {
                        return response.requestOptions.method.toLowerCase() == element.name.toLowerCase();
                      },
                    ),
                    request: response.requestOptions.data,
                    header: {
                      'token': tokenDataEntity!.accessToken!,
                    },
                  );
                  // AppLogger.debugLog("output $output");
                  return handler.resolve(output);
                } else {
                  // if (result == null || result.data == null) {
                  refreshQueue.clear();
                  _isRefreshing = false;
                  tokenDataEntity = null;

                  await AccountLocalRepository().removeLocalAccountData();
                  await AccountLocalRepository().removeRefreshToken();
                  await AccountLocalRepository().removeUserToken();
                  await AccountLocalRepository().removeDataToken();
                  await AccountLocalRepository().setIsSignOut();
                  await VehicleLocalRepository().removeLocalVehicleDataV2();
                  Get.offAll(() => const SignInPage());
                  return handler.next(error);
                }
              }
            }
          }
          _isRefreshing = false;
          refreshQueue.clear();
          return handler.next(error);
        },
      ),
    );
  }

  static Future<dio.Response> _retryRequest(dio.RequestOptions requestOptions) {
    // Clone the failed request with new access token and resend it
    final options = dio.Options(
      method: requestOptions.method,
      headers: appApiService.dio.options.headers,
    );
    return appApiService.dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
