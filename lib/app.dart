import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/repository/local/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/notification_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';
import 'package:project_vehicle_log_app/init_config.dart';
import 'package:project_vehicle_log_app/presentation/edit_profile/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_list_log_bloc/get_list_log_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/notification_screen/notification_bloc/notification_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/signout_bloc/signout_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_bloc/signin_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/presentation/signup_screen/signup_bloc/signup_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/create_log_vehicle_bloc/create_log_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/vehicle_screen/vehicle_bloc/create_vehicle_bloc/create_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isSignIn = false;
  @override
  Widget build(BuildContext context) {
    isSignIn = LocalService.instance.box.read("isSignIn");
    debugPrint("isSignIn $isSignIn");
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SigninBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(create: (context) => SignoutBloc(AccountLocalRepository(), VehicleLocalRepository())),
        BlocProvider(create: (context) => SignupBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(
            create: (context) => ProfileBloc(
                  AppAccountRepository(AppInitConfig.appInterceptors.appApiService),
                  AccountLocalRepository(),
                )),
        BlocProvider(create: (context) => CreateVehicleBloc(AppVehicleReposistory(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(create: (context) => CreateLogVehicleBloc(AppVehicleReposistory(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(create: (context) => EditProfileBloc(AppAccountRepository(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(create: (context) => NotificationBloc(AppNotificationRepository(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(create: (context) => GetAllVehicleBloc(AppVehicleReposistory(AppInitConfig.appInterceptors.appApiService))),
        BlocProvider(create: (context) => GetListLogBloc(AppVehicleReposistory(AppInitConfig.appInterceptors.appApiService))),
      ],
      child: ScreenUtilInit(
        // designSize: const Size(360, 690),
        designSize: const Size(411, 869),
        // designSize: const Size(375, 812),
        // designSize: const Size(412, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          AppTheme.appThemeInit();
          return GetMaterialApp(
            title: 'Vehicle Management Log',
            theme: AppTheme.theme,
            // home: const MainPage()
            home: (isSignIn == true) ? const MainPage() : const SignInPage(),
          );
        },
      ),
    );
  }
}
