import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/change_password_screen/change_password_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/delete_account_screen/delete_account_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/language_screen/language_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/notification_settings_screen/notification_settings_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/privacy_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/security_preferences_screen/security_preferences_screen.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/terms_and_condition_screen.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

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
      // menuTitle: "Change Password",
      menuTitle: LanguageController.language.changePassword,
      menuFunction: () {
        Get.to(
          () => const ChangePasswordScreen(),
        );
      },
    ),
    // DummyDataProfileModel(
    //   menuTitle: "Use Biometrics",
    //   menuFunction: () {},
    // ),
  ];

  static List<DummyDataProfileModel> dummyDataProfileApps = [
    DummyDataProfileModel(
      // menuTitle: "Notification Settings",
      menuTitle: LanguageController.language.notificationSettings,
      menuFunction: () {
        Get.to(
          () => const NotificationSettingsScreen(),
        );
      },
    ),
    // DummyDataProfileModel(
    //   menuTitle: "Theme",
    //   menuFunction: () {
    //     Get.to(
    //       () => const ThemeScreen(),
    //     );
    //   },
    // ),
    DummyDataProfileModel(
      // menuTitle: "Language",
      menuTitle: LanguageController.language.language,
      menuFunction: () {
        Get.to(
          () => const LanguageScreen(),
        );
      },
    ),
  ];

  static List<DummyDataProfileModel> dummyDataProfileAccount = [
    DummyDataProfileModel(
      // menuTitle: "Security Preferences",
      menuTitle: LanguageController.language.securityPreferences,
      menuFunction: () {
        Get.to(
          () => const SecurityPreferencesScreen(),
        );
      },
    ),
    DummyDataProfileModel(
      // menuTitle: "Delete Account",
      menuTitle: LanguageController.language.deleteAccount,
      menuFunction: () {
        Get.to(
          () => const DeleteAccountScreen(),
        );
      },
    ),
  ];

  static List<DummyDataProfileModel> dummyDataProfileAbout = [
    // DummyDataProfileModel(
    //   menuTitle: "About This App",
    //   menuFunction: () {
    //     Get.to(() => const AboutThisAppPage());
    //   },
    // ),
    // DummyDataProfileModel(
    //   menuTitle: "Questions and Answers",
    //   menuFunction: () {
    //     Get.to(
    //       () => const QNAPage(),
    //     );
    //   },
    // ),
    DummyDataProfileModel(
      // menuTitle: "Terms & Conditions",
      menuTitle: LanguageController.language.termsAndConditions,
      menuFunction: () {
        Get.to(() => const TermsAndConditionScreen());
      },
    ),
    DummyDataProfileModel(
      // menuTitle: "Privacy & Policy",
      menuTitle: LanguageController.language.privacyAndPolicy,
      menuFunction: () {
        Get.to(() => const PrivacyScreen());
      },
    ),
    DummyDataProfileModel(
      // menuTitle: "Rate 'Vehicle Management Logs'",
      menuTitle: "${LanguageController.language.rate} '${LanguageController.language.vehicleManagementLogs}'",
      menuFunction: () async {
        final InAppReview inAppReview = InAppReview.instance;

        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }

        await inAppReview.openStoreListing(
          appStoreId: '',
          microsoftStoreId: '',
        );
      },
    ),
  ];
}
