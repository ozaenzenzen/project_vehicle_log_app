import 'dart:async';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/refresh_token_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/local/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/account/token_data_entity.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:project_vehicle_log_app/support/app_logger.dart' as localAppLogger;

class AppInterceptors {
  AppInterceptors({
    required this.appApiService,
  });
  AppApiService appApiService;
  // AppApiService appApiService = AppApiService(EnvironmentConfig.baseUrl());
  // late AppApiService appApiService;

  TokenDataEntity? tokenDataEntity;

  bool _isRefreshing = false;
  bool _refreshFailed = false;

  List<Function> refreshQueue = [];

  Completer<void>? _refreshCompleter;

  Future<void> interceptorsLogic() async {
    tokenDataEntity = await AccountLocalRepository().getDataToken();

    // appApiService = AppApiService(EnvironmentConfig.baseUrl());

    TokenDataEntity? localTokenDataEntity;

    appApiService.dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.baseUrl.contains(AppApiPath.signInAccount) || options.baseUrl.contains(AppApiPath.signUpAccount)) {
            return handler.next(options);
          }

          var tokenDataEntity = await AccountLocalRepository().getDataToken();
          options.headers["token"] = tokenDataEntity?.accessToken;

          if (_isRefreshing) {
            if (_refreshFailed) {
              return handler.reject(
                dio.DioError(
                  requestOptions: options,
                  error: "Unauthorized",
                ),
              );
            }
            await _refreshCompleter?.future;
            options.headers["token"] = tokenDataEntity?.accessToken;
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          var response = error.response;
          var tokenDataEntity = await AccountLocalRepository().getDataToken();

          if (response == null) return handler.next(error);

          if (response.realUri.path != AppApiPath.refreshToken && response.statusCode == 401 && !_isRefreshing) {
            _isRefreshing = true;
            _refreshCompleter = Completer<void>();

            try {
              AppAccountRepository accountRepository = AppAccountRepository(appApiService);
              AppLogger.debugLog("tokenDataEntity!.accessToken!: ${tokenDataEntity!.accessToken!}");
              AppLogger.debugLog("tokenDataEntity!.refreshToken!: ${tokenDataEntity.refreshToken!}");
              RefreshTokenResponseModel? result = await accountRepository.refreshToken(
                refreshToken: tokenDataEntity.refreshToken!,
                token: tokenDataEntity.accessToken!,
              );
              if (result!.data != null) {
                _refreshFailed = false;
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
                final options = error.requestOptions;
                options.headers["token"] = tokenDataEntity?.accessToken;
                final response = await _retryRequest(options);
                return handler.resolve(response);
              } else {
                _refreshFailed = true;
                await redirectToLogin();
                return handler.reject(error);
              }
            } finally {
              _isRefreshing = false;
              _refreshCompleter?.complete();
              _refreshCompleter = null;
            }
          } else if (_isRefreshing) {
            await _refreshCompleter?.future;
            if (!_refreshFailed) {
              final options = error.requestOptions;
              options.headers["token"] = tokenDataEntity?.accessToken;
              final response = await _retryRequest(options);
              return handler.resolve(response);
            } else {
              return handler.reject(
                dio.DioError(requestOptions: error.requestOptions, error: 'Unauthorized'),
              );
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> redirectToLogin() async {
    await AccountLocalRepository().removeLocalAccountData();
    await AccountLocalRepository().removeRefreshToken();
    await AccountLocalRepository().removeUserToken();
    await AccountLocalRepository().removeDataToken();
    await AccountLocalRepository().setIsSignOut();
    await VehicleLocalRepository().removeLocalVehicleDataV2();
    Get.offAll(() => const SignInPage());
  }

  Future<void> interceptorsLogic2() async {
    tokenDataEntity = await AccountLocalRepository().getDataToken();

    appApiService = AppApiService(EnvironmentConfig.baseUrl());

    TokenDataEntity? localTokenDataEntity;

    appApiService.dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          var tokenDataEntity = await AccountLocalRepository().getDataToken();
          options.headers["token"] = tokenDataEntity?.accessToken;
          return handler.next(options);
        },
        onError: (error, handler) async {
          var response = error.response;
          var tokenDataEntity = await AccountLocalRepository().getDataToken();

          if (response == null) return handler.next(error);

          if (response.realUri.path != AppApiPath.refreshToken && response.statusCode == 401) {
            if (_isRefreshing) {
              // Queue the requests while refreshing
              refreshQueue.add(() async {
                final response = await _retryRequest(error.requestOptions);
                handler.resolve(response);
              });
              return;
            }

            _isRefreshing = true;

            try {
              AppAccountRepository accountRepository = AppAccountRepository(appApiService);
              AppLogger.debugLog("tokenDataEntity!.refreshToken!: ${tokenDataEntity!.refreshToken!}");
              AppLogger.debugLog("tokenDataEntity!.accessToken!: ${tokenDataEntity.accessToken!}");
              RefreshTokenResponseModel? result = await accountRepository.refreshToken(
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
              } else {
                await redirectToLogin();
                return handler.reject(error);
              }

              // Retry all queued requests with the new token
              for (var request in refreshQueue) {
                await request();
              }
              refreshQueue.clear();

              // Retry the original failed request
              final response = await _retryRequest(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              // Clear token data and sign the user out on refresh failure
              await redirectToLogin();
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

  Future<dio.Response> _retryRequest(dio.RequestOptions requestOptions) {
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
