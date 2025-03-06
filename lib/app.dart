import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/repository/local/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/device_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/notification_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';

import 'package:project_vehicle_log_app/init_config_v2.dart';
import 'package:project_vehicle_log_app/presentation/edit_profile/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/change_password_forgot_password_bloc/change_password_forgot_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/send_otp_forgot_password_bloc/send_otp_forgot_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/validate_otp_forgot_password_bloc/validate_otp_forgot_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/notification_screen/notification_bloc/notification_bloc.dart';
import 'package:project_vehicle_log_app/presentation/otp_verification_screen/otp_validation_bloc/otp_validation_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/signout_bloc/signout_bloc.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/change_password_screen/change_password_bloc/change_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/delete_account_screen/delete_account_bloc/delete_account_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_bloc/signin_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/presentation/signup_screen/signup_bloc/signup_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/create_log_vehicle_bloc/create_log_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/create_vehicle_bloc/create_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language_bloc/language_bloc.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';

import 'package:nested/nested.dart';

class MyApp extends StatefulWidget {
  // static final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

  // MyApp({Key? key}) : super(key: myAppKey);
  // MyApp({Key? key}) : super(key: myAppKey);

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isSignIn = false;

  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = LanguageController.language.locale1;
  }

  List<SingleChildWidget> providers = [
    BlocProvider(create: (context) => LanguageBloc()),
    BlocProvider(
        create: (context) => SigninBloc(
              AppAccountRepository(AppInitConfig.appInterceptors.appApiService),
              DeviceRepository(AppInitConfig.appInterceptors.appApiService),
            )),
    BlocProvider(create: (context) => SignoutBloc(AccountLocalRepository(), VehicleLocalRepository())),
    BlocProvider(create: (context) => SignupBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => ChangePasswordBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => OtpValidationBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => DeleteAccountBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => SendOtpForgotPasswordBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => ValidateOtpForgotPasswordBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => ChangePasswordForgotPasswordBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(
        create: (context) => ProfileBloc(
              AppAccountRepository(AppInitConfig.appInterceptors.appApiService),
              AccountLocalRepository(),
            )),
    BlocProvider(create: (context) => CreateVehicleBloc(AppVehicleRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => CreateLogVehicleBloc(AppVehicleRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => EditProfileBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => NotificationBloc(AppNotificationRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => GetAllVehicleBloc(AppVehicleRepository(AppInitConfig.appInterceptors.appApiService))),
    BlocProvider(create: (context) => GetListLogBloc(AppVehicleRepository(AppInitConfig.appInterceptors.appApiService))),
  ];

  @override
  Widget build(BuildContext context) {
    isSignIn = LocalService.instance.box.read("isSignIn");
    debugPrint("isSignIn $isSignIn");
    return MultiBlocProvider(
      providers: providers,
      child: ScreenUtilInit(
        // designSize: const Size(360, 690),
        designSize: const Size(411, 869),
        // designSize: const Size(375, 812),
        // designSize: const Size(412, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          AppTheme.appThemeInit();
          return BlocListener<LanguageBloc, LanguageState>(
            listener: (context, state) {
              AppLoggerCS.debugLog("state: $state");
              if (state is LanguageSuccess) {
                setState(() {
                  _locale = state.language.locale1;
                  AppLoggerCS.debugLog("_locale: $_locale");
                });
              }
            },
            child: GetMaterialApp(
              title: 'Vehicle Management Log',
              locale: _locale,
              theme: AppTheme.theme,
              home: (isSignIn == true) ? const MainPage() : const SignInPage(),
            ),
          );
        },
      ),
    );
  }
}
