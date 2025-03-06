import 'package:project_vehicle_log_app/support/config/language/app_language.dart';

abstract class Language with AppLanguage {
  late String language;
  late String languageIndonesia;
  late String languageEnglish;
  late String addVehicle;

  late String homeMenu;
  late String vehicleMenu;
  late String statsMenu;
  late String profileMenu;


  // Popup 
  late String errorTitle1;
  late String errorTitle2;
  late String successTitle;
  late String backButton;

  // Signin Screen
  late String appTitle;
  late String enter;
  late String forgotPassword;
  late String haveAnAccount;
  late String register;
  late String chooseLanguage;
  late String email;
  late String password;

  // Register Screen
  late String registerAccount;
  late String registerName;
  late String registerEmail;
  late String registerPhone;
  late String registerPassword;
  late String registerConfirmPassword;
  late String alreadyHaveAnAccount;

  // Home Screen
  late String home;
  late String manageYourVehicleMileage;
  late String currentDate;
  late String summary;
  late String numberOfVehicle;
  late String measurement;
  late String lastUpdate;
  late String frequentMeasurement;
  late String costBreakdown;

  // Profile Screen
  late String myProfile;
  late String profile;
  late String apps;
  late String notificationSettings;
  // late String language;
  late String account;
  late String securityPreferences;
  late String deleteAccount;
  late String about;
  late String termsAndConditions;
  late String privacyAndPolicy;
  late String rate;
  late String vehicleManagementLogs;
  late String changePassword;
  late String warning;
  // late String warning2;
  late String infoDeleteAccountDescription;
  late String reason;
  late String editProfile;
  late String logout;

  // Notification Settings Screen
  late String open;
  late String openNotificationSettings;
}
