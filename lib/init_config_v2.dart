import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/support/app_interceptors.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';

class AppInitConfig {
  static FamCodingSupply famCodingSupply = FamCodingSupply();

  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  static late AppInterceptors appInterceptors;

  static Future<void> init() async {
    AppLoggerCS.useLogger = true;
    // AppTheme.appThemeInit();
    await GetStorage.init();
    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();

    // EnvironmentConfig.customBaseUrl = "https://4be5-112-215-170-211.ngrok.io"; // for ngrok
    EnvironmentConfig.customBaseUrl = "https://730e-114-10-42-84.ngrok-free.app"; // for ngrok
    // EnvironmentConfig.customBaseUrl = "http://10.0.2.2:8080"; // for emulator android
    // EnvironmentConfig.customBaseUrl = "http://localhost:8080"; // for emulator iOS

    appInterceptors = AppInterceptors(appApiService: appApiService);

    // await appInterceptors.interceptorsLogic();
    await appInterceptors.interceptorsLogic2();
  }
}
