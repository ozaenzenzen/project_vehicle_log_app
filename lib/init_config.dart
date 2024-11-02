import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/support/app_connectivity_service.dart';
import 'package:project_vehicle_log_app/support/app_device_info.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_interceptors.dart';
import 'package:project_vehicle_log_app/support/app_local_storage.dart';

class AppInitConfig {
  static AppInterceptors appInterceptors = AppInterceptors();

  static Future<void> init() async {
    // AppTheme.appThemeInit();
    await GetStorage.init();
    await AppInfo.appInfoInit();
    await AppConnectivityService.init();
    await AppLocalStorage.init();
    await AppDeviceInfo().getDeviceData();

    // EnvironmentConfig.customBaseUrl = "https://4be5-112-215-170-211.ngrok.io"; // for ngrok
    EnvironmentConfig.customBaseUrl = "https://678f-182-2-166-213.ngrok-free.app"; // for ngrok
    // EnvironmentConfig.customBaseUrl = "http://10.0.2.2:8080"; // for emulator android
    // EnvironmentConfig.customBaseUrl = "http://localhost:8080"; // for emulator iOS

    // await appInterceptors.interceptorsLogic();
    await appInterceptors.interceptorsLogic2();
  }
}
