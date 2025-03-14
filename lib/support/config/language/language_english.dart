import 'dart:ui';

import 'package:project_vehicle_log_app/support/config/language/language.dart';

class LanguageEnglish implements Language {
  @override
  String? languageImage = "assets/icons/icon_flag_english.png";

  @override
  String languageName = "English";

  @override
  String locale = "en_US";

  @override
  String appTitle = "Vehicle Log Apps";

  @override
  String enter = "Enter";

  @override
  String forgotPassword = "Forgot Password";

  @override
  String haveAnAccount = "Don't have an account yet?";

  @override
  String register = "Register";

  @override
  String chooseLanguage = "Choose Language";

  @override
  String email = "Email";

  @override
  String password = "Password";

  @override
  String alreadyHaveAnAccount = "Already Have an Account?";

  @override
  String registerAccount = "Account Register";

  @override
  String registerConfirmPassword = "Confirm Password";

  @override
  String registerEmail = "Email";

  @override
  String registerName = "Name";

  @override
  String registerPassword = "Password";

  @override
  String registerPhone = "Phone";

  @override
  String languageEnglish = "English";

  @override
  String languageIndonesia = "Bahasa Indonesia";

  // Home Screen
  @override
  String language = "Language";

  @override
  String costBreakdown = "Cost Breakdown";

  @override
  String currentDate = "Current Date";

  @override
  String frequentMeasurement = "Frequent Measurement";

  @override
  String home = "Home";

  @override
  String lastUpdate = "Last Update";

  @override
  String manageYourVehicleMileage = "Manage your vehicle mileage";

  @override
  String measurement = "Measurement";

  @override
  String numberOfVehicle = "Number of Vehicle";

  @override
  String summary = "Summary";

  @override
  String addVehicle = "Add Vehicle";

  @override
  Locale locale1 = const Locale("en", "US");

  @override
  String about = "About";

  @override
  String account = "Account";

  @override
  String apps = "Apps";

  @override
  String deleteAccount = "Delete Account";

  @override
  String myProfile = "My Profile";

  @override
  String notificationSettings = "Notification Settings";

  @override
  String privacyAndPolicy = "Privacy And Policy";

  @override
  String profile = "Profile";

  @override
  String rate = "Rate";

  @override
  String securityPreferences = "Security Preferences";

  @override
  String termsAndConditions = "Terms And Conditions";

  @override
  String vehicleManagementLogs = "Vehicle Management Logs";

  @override
  String changePassword = "Change Password";

  @override
  String infoDeleteAccountDescription =
      "This will permanent and cannot be undone! Your account will be deactivated in 30 days before it permanently deleted.\nYou can contact Customer Service for activation";

  @override
  String reason = "Any reason you want to share";

  @override
  String warning = "Warning";

  @override
  String editProfile = "Edit Profile";

  @override
  String logout = "Logout";

  @override
  String open = "Open";

  @override
  String openNotificationSettings = "Open Notification Settings";

  @override
  String errorTitle1 = "Error!";

  @override
  String errorTitle2 = "Oops..!";

  @override
  String backButton = "Back"; 
  
  @override
  String successTitle = "Success";

  @override
  String homeMenu = "Home";
  
  @override
  String profileMenu = "Profile";
  
  @override
  String statsMenu = "Stats";
  
  @override
  String vehicleMenu = "Vehicle";

  @override
  String emailTextFieldLabel = "Email";
  
  @override
  String nameTextFieldLabel = "Name";
  
  @override
  String phoneNumberTextFieldLabel = "Phone Number";
  
  @override
  String update = "Update";
  
  @override
  String updateProfile = "Update Profile";

  @override
  String emptyState = "You have not added vehicle data";
  
  @override
  String stats = "Stats";
  
  @override
  String statsMainDescription = "Displays stats based on your vehicle";
  
  @override
  String vehicleMainDescription = "Choose your vehicle";
  
  @override
  String yourVehicle = "Your vehicle";

  @override
  String emptyStateMilage= "You have not added any measurement data";

  @override
  String add = "Add";
  
  @override
  String addVehicleMainDescription = "Add your vehicle alongside with measurement parameter";
  
  @override
  String browseFile = "Browse File";
  
  @override
  String browseImage = "Browse Image";
  
  @override
  String chassisNumber = "Chassis Number";
  
  @override
  String color = "Color";
  
  @override
  String documentFormat = "Document Format";
  
  @override
  String engineCapacity = "Engine Capacity";
  
  @override
  String litre = "Litre";
  
  @override
  String machineNumber = "Machine Number";
  
  @override
  String tankCapacity = "Tank Capacity";
  
  @override
  String vehicleImage = "Vehicle Image";
  
  @override
  String vehicleName = "Vehicle Name";
  
  @override
  String year = "Year";

  @override
  String vehicleImageNotes = "We reduce the size of the image you selected for a better experience";

  @override
  String example = "Example";
  
  @override
  String exampleShort = "Ex:";

  @override
  String addMeasurement = "Add Measurement";
  
  @override
  String detailMeasurementDescription = "Show stats from your vehicle";
  
  @override
  String expenses = "Expenses";
  
  @override
  String logs = "Logs";
  
  @override
  String odoChanges = "Odo Changes";
  
  @override
  String seeVehicleLogs = "See Vehicle Logs";
  
  @override
  String statsOf = "Stats of";

  @override
  String date = "Date";

  @override
  String time = "Time";

  @override
  String amount = "Amount";
  
  @override
  String chooseYourLog = "Choose your log";
  
  @override
  String dateUpdated = "Date Updated";
  
  @override
  String day = "Day";
  
  @override
  String hour = "Hour";
  
  @override
  String info = "Info";
  
  @override
  String justNow = "Just now";
  
  @override
  String mainInfo = "Main Info";
  
  @override
  String minute = "Minute";
  
  @override
  String newOdo = "New Odo";
  
  @override
  String notes = "Notes";
  
  @override
  String second = "Second";

  @override
  String daysAgo = "day(s) ago";
  
  @override
  String hoursAgo = "hour(s) ago";
  
  @override
  String minutesAgo = "minute(s) ago";
  
  @override
  String secondsAgo = "second(s) ago";

  @override
  String detailVehicle = "Detail vehicle";

  @override
  String editVehicle = "Edit Vehicle";
  
  @override
  String editVehicleDescription = "Edit your vehicle alongside with measurement parameter";

  @override
  String amountExpenses = "Amount Expenses";
  
  @override
  String checkpointDate = "Checkpoint Date";
  
  @override
  String currentOdo = "Current Odo";
  
  @override
  String estimateOdoChanging = "Estimate Odo Changing";
  
  @override
  String measurementTitle = "Measurement Title";

  @override
  String editMeasurement= "Edit Measurement";

  @override
  String addOtherService = "Add Other Service";
  
  @override
  String selectService = "Select Service";

  @override
  String confirmNewPassword = "Confirm New Password";
  
  @override
  String newPassword = "New Password";
  
  @override
  String oldPassword = "Old Password";
}
