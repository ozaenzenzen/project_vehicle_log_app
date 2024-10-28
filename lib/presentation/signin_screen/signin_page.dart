import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/forgot_password_screen.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_bloc/signin_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signup_screen/signup_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailTextFieldController = TextEditingController(text: "");
  TextEditingController passwordTextFieldController = TextEditingController(text: "");

  bool keepLogin = false;

  bool isHidePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         FutureBuilder(
            //           future: AppInfo.showAppVersion(),
            //           builder: (context, snapshot) {
            //             return Text(
            //               // "Vehicle Log Apps Version 1.0.0+1",
            //               // "Vehicle Log Apps Version ${AppInfo.appVersion}",
            //               "Vehicle Log Apps Version ${snapshot.data}",
            //               style: AppTheme.theme.textTheme.bodySmall?.copyWith(
            //                 fontSize: 10.sp,
            //                 color: Colors.grey,
            //                 fontWeight: FontWeight.w400,
            //               ),
            //             );
            //           },
            //         ),
            //         SizedBox(height: 10.h),
            //       ],
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Spacer(),
                  SizedBox(height: 100.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Vehicle Log Apps",
                      style: AppTheme.theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 100.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Masuk",
                      style: AppTheme.theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  AppTextFieldWidget(
                    textFieldTitle: "Email",
                    textFieldHintText: "journalist@email.com",
                    controller: emailTextFieldController,
                  ),
                  SizedBox(height: 10.h),
                  AppTextFieldWidget(
                    textFieldTitle: "Password",
                    textFieldHintText: "*****",
                    controller: passwordTextFieldController,
                    obscureText: isHidePassword,
                    textInputAction: TextInputAction.go,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          isHidePassword = !isHidePassword;
                        });
                      },
                      child: Icon(
                        isHidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    onSubmitted: (String value) {
                      context.read<SigninBloc>().add(
                            SigninAction(
                              signInRequestModel: SignInRequestModel(
                                email: emailTextFieldController.text,
                                password: passwordTextFieldController.text,
                              ),
                              appVehicleReposistory: AppVehicleReposistory(),
                              vehicleLocalRepository: VehicleLocalRepository(),
                            ),
                          );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const ForgotPasswordScreen());
                        },
                        child: Text(
                          "Forgot Password",
                          style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 14.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  BlocConsumer<SigninBloc, SigninState>(
                    listener: (context, state) {
                      if (state is SigninFailed) {
                        AppDialogAction.showFailedPopup(
                          title: 'Terjadi kesalahan',
                          description: state.errorMessage,
                          buttonTitle: 'Kembali',
                          context: context,
                        );
                      } else if (state is SigninSuccess) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.read<GetAllVehicleBloc>().add(
                              GetAllVehicleRemoteAction(
                                reqData: GetAllVehicleRequestModelV2(
                                  limit: 10,
                                  currentPage: 1,
                                ),
                                action: GetAllVehicleActionEnum.refresh,
                              ),
                            );
                        // await context.read<GetAllVehicleBloc>().stream.firstWhere(
                        //       (state) => state is GetAllVehicleSuccess || state is GetAllVehicleFailed,
                        //     );
                        Get.offAll(
                          () => const MainPage(),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is SigninLoading) {
                        return const AppLoadingIndicator();
                      } else {
                        return Column(
                          children: [
                            AppMainButtonWidget(
                              onPressed: () {
                                context.read<SigninBloc>().add(
                                      SigninAction(
                                        signInRequestModel: SignInRequestModel(
                                          email: emailTextFieldController.text,
                                          password: passwordTextFieldController.text,
                                        ),
                                        appVehicleReposistory: AppVehicleReposistory(),
                                        vehicleLocalRepository: VehicleLocalRepository(),
                                      ),
                                    );
                                // Get.offAll(
                                //   () => const MainPage(),
                                // );
                              },
                              text: "Masuk",
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Belum Ada Akun?",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            AppMainButtonWidget(
                              onPressed: () {
                                Get.to(
                                  () => const SignUpPage(),
                                );
                              },
                              text: "Daftar",
                            ),
                            SizedBox(height: 20.h),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 150.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FutureBuilder(
                      future: AppInfo.showAppVersion(),
                      builder: (context, snapshot) {
                        return Text(
                          // "Vehicle Log Apps Version 1.0.0+1",
                          // "Vehicle Log Apps Version ${AppInfo.appVersion}",
                          "Vehicle Log Apps Version ${snapshot.data}",
                          style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                  // const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
