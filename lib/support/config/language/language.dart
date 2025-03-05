import 'package:project_vehicle_log_app/support/config/language/app_language.dart';

abstract class Language with AppLanguage {
  late String language;
  late String languageIndonesia;
  late String languageEnglish;

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
}
