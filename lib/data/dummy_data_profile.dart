import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/about_this_app_screen/about_this_app_page.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/change_password_screen/change_password_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/delete_account_screen/delete_account_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/language_screen/language_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/notification_settings_screen/notification_settings_screen.dart';
import 'package:project_vehicle_log_app/presentation/qna_screen/qna_page.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/security_preferences_screen/security_preferences_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/theme_screen/theme_screen.dart';

class DummyDataProfileModel {
  String? menuTitle;
  String? menuDescription;
  Function()? menuFunction;

  DummyDataProfileModel({
    required this.menuTitle,
    this.menuDescription,
    required this.menuFunction,
  });
}

class ProfileMenuSettings {
  static List<DummyDataProfileModel> securityPrefrerencesMenuItem = [
    DummyDataProfileModel(
      menuTitle: "Change Password",
      menuFunction: () {
        Get.to(
          () => const ChangePasswordScreen(),
        );
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Use Biometrics",
      menuFunction: () {},
    ),
  ];

  static List<DummyDataProfileModel> dummyDataProfileApps = [
    DummyDataProfileModel(
      menuTitle: "Notification Settings",
      menuFunction: () {
        Get.to(
          () => const NotificationSettingsScreen(),
        );
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Theme",
      menuFunction: () {
        Get.to(
          () => const ThemeScreen(),
        );
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Language",
      menuFunction: () {
        Get.to(
          () => const LanguageScreen(),
        );
      },
    ),
  ];

  static List<DummyDataProfileModel> dummyDataProfileAccount = [
    DummyDataProfileModel(
      menuTitle: "Security Preferences",
      menuFunction: () {
        Get.to(
          () => const SecurityPreferencesScreen(),
        );
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Delete Account",
      menuFunction: () {
        Get.to(
          () => const DeleteAccountScreen(),
        );
      },
    ),
  ];

  static List<DummyDataProfileModel> dummyDataProfileAbout = [
    DummyDataProfileModel(
      menuTitle: "About This App",
      menuFunction: () {
        Get.to(() => const AboutThisAppPage());
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Questions and Answers",
      menuFunction: () {
        Get.to(
          () => const QNAPage(),
        );
      },
    ),
    DummyDataProfileModel(
      menuTitle: "Terms & Conditions",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Privacy & Policy",
      menuFunction: () {},
    ),
    DummyDataProfileModel(
      menuTitle: "Rate 'Vehicle Management Logs'",
      menuFunction: () {},
    ),
  ];
}
