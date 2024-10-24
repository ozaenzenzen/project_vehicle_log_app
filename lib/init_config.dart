import 'package:get_storage/get_storage.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/support/app_connectivity_service.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_local_storage.dart';

class AppInitConfig {
  static Future<void> init() async {
    // AppTheme.appThemeInit();
    await GetStorage.init();
    AppInfo.appInfoInit();
    AppConnectivityService.init();
    AppLocalStorage.init();
    // EnvironmentConfig.customBaseUrl = "https://4be5-112-215-170-211.ngrok.io"; // for ngrok

    EnvironmentConfig.customBaseUrl = "https://96ae-114-10-42-123.ngrok-free.app"; // for ngrok

    // EnvironmentConfig.customBaseUrl = "http://10.0.2.2:8080"; // for emulator android
    // EnvironmentConfig.customBaseUrl = "http://localhost:8080"; // for emulator iOS
  }
}
