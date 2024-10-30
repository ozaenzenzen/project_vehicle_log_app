import 'package:dio/dio.dart';
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

class AppInitConfig {
  static late AppApiService appApiService;
  static TokenDataEntity? tokenDataEntity;

  static Future<void> init() async {
    // AppTheme.appThemeInit();
    await GetStorage.init();
    await AppInfo.appInfoInit();
    await AppConnectivityService.init();
    await AppLocalStorage.init();
    // EnvironmentConfig.customBaseUrl = "https://4be5-112-215-170-211.ngrok.io"; // for ngrok

    EnvironmentConfig.customBaseUrl = "https://0b5b-114-10-42-123.ngrok-free.app"; // for ngrok

    appApiService = AppApiService(EnvironmentConfig.baseUrl());

    appApiService.dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          var response = error.response;
          if (response == null) {
            return handler.next(error);
          }

          if (response.realUri.path != AppApiPath.signUpAccount && response.realUri.path != AppApiPath.signInAccount && response.realUri.path != AppApiPath.refreshToken && response.statusCode == 401) {
            if (response.realUri.path.startsWith("/vehicle") || response.realUri.path.startsWith("/notifications")) {
              AppAccountReposistory accountReposistory = AppAccountReposistory(appApiService);
              if (tokenDataEntity != null || tokenDataEntity?.accessToken != null || tokenDataEntity?.refreshToken != null) {
                RefreshTokenResponseModel? result = await accountReposistory.refreshToken(
                  refreshToken: tokenDataEntity!.refreshToken!,
                  token: tokenDataEntity!.accessToken!,
                );
                if (result == null) {
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

              return handler.resolve(
                await AppApiService(EnvironmentConfig.baseUrl()).call(response.requestOptions.uri.toString(), method: MethodRequest.values.firstWhere(
                  (element) {
                    return response.requestOptions.method.toLowerCase() == element.name.toLowerCase();
                  },
                ), header: {
                  'token': tokenDataEntity!.accessToken!,
                }),
              );
            }
          }
          return handler.next(error);
        },
      ),
    );

    // EnvironmentConfig.customBaseUrl = "http://10.0.2.2:8080"; // for emulator android
    // EnvironmentConfig.customBaseUrl = "http://localhost:8080"; // for emulator iOS
  }
}
