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

  late String emptyState;
  late String emptyStateMilage;

  late String login;

  // Success Error wording
  late String emptyData; 
  late String tryAgain; 
  late String tryAgainInAMoment; 

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
  late String emailHintText;

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

  // Edit Profile Screen
  late String nameTextFieldLabel;
  late String emailTextFieldLabel;
  late String phoneNumberTextFieldLabel;
  late String updateProfile;
  late String update;

  // Vehicle Screen
  late String yourVehicle;
  late String vehicleMainDescription;

  // Vehicle Screen
  late String stats;
  late String statsMainDescription;

  // Add Vehicle Screen
  late String addVehicleMainDescription;
  late String vehicleImage;
  late String vehicleName;
  late String year;
  late String engineCapacity;
  late String tankCapacity;
  late String color;
  late String machineNumber;
  late String chassisNumber;
  late String add;
  late String litre;
  late String browseFile;
  late String browseImage;
  late String documentFormat;
  late String vehicleImageNotes;
  late String example;
  late String exampleShort;

  // Detail Measurement Screen
  late String statsOf;
  late String detailMeasurementDescription;
  late String seeVehicleLogs;
  late String logs;
  late String expenses;
  late String odoChanges;
  late String addMeasurement;
  late String date;
  late String time;

  // Detail Vehicle Screen
  late String detailVehicle;
  late String info;
  late String mainInfo;
  late String newOdo;
  late String dateUpdated;
  late String amount;
  late String notes;
  late String day;
  late String hour;
  late String minute;
  late String second;
  late String justNow;
  late String chooseYourLog;
  late String daysAgo;
  late String hoursAgo;
  late String minutesAgo;
  late String secondsAgo;

  // Edit Vehicle Screen
  late String editVehicle;
  late String editVehicleDescription;

  // Edit Measurement Screen
  late String editMeasurement;
  late String measurementTitle;
  late String currentOdo;
  late String estimateOdoChanging;
  late String amountExpenses;
  late String checkpointDate;

  // Add Measurement Screen
  late String selectService;
  late String addOtherService;

  // Change Password Screen
  late String oldPassword;
  late String newPassword;
  late String confirmNewPassword;
}
