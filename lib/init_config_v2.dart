import 'dart:async';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/support/app_interceptors.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';
import 'package:project_vehicle_log_app/support/config/language/language_english.dart';
import 'package:project_vehicle_log_app/support/config/language/language_indonesia.dart';
import 'package:project_vehicle_log_app/support/config/language/language.dart';

class AppInitConfig {
  static FamCodingSupply famCodingSupply = FamCodingSupply();

  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  static late AppInterceptors appInterceptors;

  // static final supportedLang = [
  //   Language(
  //     language: "Indonesia",
  //     locale: Locale("id", "ID"),
  //     key: {
  //       ...(AccLang.ID),
  //       ...(QoinServicesLocalization.indoLanguageMap),
  //       ...(QoinTransactionLocalization.indoLanguageMap),
  //       ...(DigitalIdLang.ID),
  //       ...(QWLocalization.ID)
  //     },
  //   ),
  //   Language(
  //     language: "English",
  //     locale: Locale("en", "US"),
  //     key: {
  //       ...(AccLang.EN),
  //       ...(QoinServicesLocalization.engLanguageMap),
  //       ...(QoinTransactionLocalization.engLanguageMap),
  //       ...(DigitalIdLang.EN),
  //       ...(QWLocalization.EN)
  //     },
  //   ),
  // ];

  static Future<void> init() async {
    AppLoggerCS.useLogger = true;
    // AppTheme.appThemeInit();
    await GetStorage.init();
    await LanguageController.init();
    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();

    // EnvironmentConfig.customBaseUrl = "https://4be5-112-215-170-211.ngrok.io"; // for ngrok
    EnvironmentConfig.customBaseUrl = "https://219c-114-10-42-224.ngrok-free.app"; // for ngrok
    // EnvironmentConfig.customBaseUrl = "http://10.0.2.2:8080"; // for emulator android
    // EnvironmentConfig.customBaseUrl = "http://localhost:8080"; // for emulator iOS

    appInterceptors = AppInterceptors(appApiService: appApiService);

    // await appInterceptors.interceptorsLogic();
    await appInterceptors.interceptorsLogic2();
  }
}
