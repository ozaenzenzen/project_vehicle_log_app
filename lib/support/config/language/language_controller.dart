import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/support/config/language/language.dart';
import 'package:project_vehicle_log_app/support/config/language/language_english.dart';
import 'package:project_vehicle_log_app/support/config/language/language_indonesia.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';

class LanguageController {
  static List<Language> languages = [
    LanguageIndonesia(),
    LanguageEnglish(),
  ];

  // static Language defaultLanguage = languages.first;
  static Language defaultLanguage = languages.first;

  static Language language = defaultLanguage;

  static Future<Language> switchLanguage(BuildContext context, Language value) async {
    try {
      language = value;
      AppLoggerCS.debugLog("switchLanguage: ${language.locale}");
      // MyApp.setLocale(context, value.locale1);
      // MyApp.myAppKey.currentState?.setLocale(context, value.locale1);
      // MyApp.myAppKey.currentState?.setLocale(value.locale1);
      await _setSavedLanguage(data: value.locale);
      return language;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Latest Language in Memory
  static Future<void> init() async {
    String? value = await _getSavedLanguage();
    if (value != null) {
      language = languages.firstWhere((element) => element.locale == value);
    }

    // String? value = await getSavedLanguage();
    // if (value != null) {
    //   for (var lang in LanguageController.languages) {
    //     if (lang.locale == value) {
    //       switchLanguage(lang);
    //     } else if (lang.locale.split("_")[0] == value.split("_")[0]) {
    //       switchLanguage(lang);
    //     }
    //   }
    // }
  }

  static const String _keyLocale = 'locale';

  static Future<void> _setSavedLanguage({
    required String data,
  }) async {
    try {
      await LocalService.instance.box.write(_keyLocale, data);
      AppLoggerCS.debugLog("[setSavedLanguage] saved language");
    } catch (e) {
      AppLoggerCS.debugLog("[setSavedLanguage][error] $e");
      rethrow;
    }
  }

  static Future<String?> _getSavedLanguage() async {
    try {
      var output = await LocalService.instance.box.read(_keyLocale);
      AppLoggerCS.debugLog("getSavedLanguage: $output");
      if (output != null) {
        return output;
      } else {
        return null;
      }
    } catch (e) {
      AppLoggerCS.debugLog("[getSavedLanguage][error] $e");
      // return null;
      rethrow;
    }
  }
}
