import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/logic/app_bottomsheet_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/forgot_password_screen.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/bloc/get_all_vehicle_bloc/get_all_vehicle_bloc.dart';
import 'package:project_vehicle_log_app/presentation/main_page.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_bloc/signin_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signup_screen/signup_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language.dart';
import 'package:project_vehicle_log_app/support/config/language/language_bloc/language_bloc.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

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
  void initState() {
    super.initState();
    // emailTextFieldController.text = "recovery252@gmail.com";
    // passwordTextFieldController.text = "example";
    // emailTextFieldController.text = "tkdbintara@gmail.com";
    // passwordTextFieldController.text = "example";
    emailTextFieldController.text = "example1@test.com";
    passwordTextFieldController.text = "example";
  }

  bool isEnglish = false;

  Language language = LanguageController.language;
  // String language = "Bahasa Indonesia";

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
                      LanguageController.language.enter,
                      // "Masuk",
                      style: AppTheme.theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  AppTextFieldWidget(
                    textFieldTitle: LanguageController.language.email,
                    // textFieldTitle: "Email",
                    textFieldHintText: "journalist@email.com",
                    controller: emailTextFieldController,
                  ),
                  SizedBox(height: 10.h),
                  AppTextFieldWidget(
                    textFieldTitle: LanguageController.language.password,
                    // textFieldTitle: "Password",
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
                          LanguageController.language.forgotPassword,
                          // "Forgot Password",
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
                        AppDialogActionCS.showFailedPopup(
                          title: 'Terjadi kesalahan',
                          description: state.errorMessage,
                          buttonTitle: 'Kembali',
                          context: context,
                          mainButtonAction: () {
                            Get.back();
                          },
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
                                      ),
                                    );
                                // Get.offAll(
                                //   () => const MainPage(),
                                // );
                              },
                              text: LanguageController.language.enter,
                              // text: "Masuk",
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              LanguageController.language.haveAnAccount,
                              // "Belum Ada Akun?",
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
                              text: LanguageController.language.register,
                              // text: "Daftar",
                            ),
                            SizedBox(height: 20.h),
                            // Switch.adaptive(
                            //   // This bool value toggles the switch.
                            //   trackOutlineColor: MaterialStateProperty.resolveWith(
                            //     (final Set<MaterialState> states) {
                            //       if (states.contains(MaterialState.selected)) {
                            //         return null;
                            //       }

                            //       return Colors.grey;
                            //     },
                            //   ),
                            //   value: isEnglish,
                            //   activeColor: AppColorCS.blue,
                            //   inactiveThumbColor: Colors.grey,
                            //   onChanged: (bool value) {
                            //     // This is called when the user toggles the switch.
                            //     setState(() {
                            //       isEnglish = value;
                            //     });
                            //   },
                            // ),
                            // Switch(
                            //   activeColor: Colors.red,
                            //   value: isEnglish,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       isEnglish = value;
                            //     });
                            //   },
                            // ),
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
            SafeArea(
              child: Column(
                children: [
                  Container(
                    height: kToolbarHeight,
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            // AppBottomSheetAction().showBottomSheetV3(
                            AppBottomSheetUtilsCS().showAppBottomSheet(
                              context,
                              title: LanguageController.language.chooseLanguage,
                              // title: "Choose Language",
                              radius: 12.h,
                              isBottomSheetOpen: (isOpen) {
                                if (!isOpen) {
                                  setState(() {});
                                }
                              },
                              content: StatefulBuilder(builder: (context, setState1) {
                                return Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (language != LanguageController.languages[0]) {
                                            language = LanguageController.languages[0];
                                            // await LanguageController.switchLanguage(context, language);
                                            context.read<LanguageBloc>().add(ChangeLanguageAction(context: context, language: language));
                                          }
                                          setState1(() {});
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              "assets/icons/icon_flag_indonesia.png",
                                              height: 24.h,
                                              width: 24.h,
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Text(
                                                "Bahasa Indonesia",
                                                // LanguageController.language.languageName,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Radio<Language>(
                                              value: LanguageController.languages[0],
                                              groupValue: language,
                                              onChanged: (value) async {
                                                if (language != value) {
                                                  language = value!;
                                                  // await LanguageController.switchLanguage(context, value);
                                                  context.read<LanguageBloc>().add(ChangeLanguageAction(context: context, language: language));
                                                }
                                                setState1(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      InkWell(
                                        onTap: () async {
                                          if (language != LanguageController.languages[1]) {
                                            language = LanguageController.languages[1];
                                            // await LanguageController.switchLanguage(context, language);
                                            context.read<LanguageBloc>().add(ChangeLanguageAction(context: context, language: language));
                                          }
                                          setState1(() {});
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              "assets/icons/icon_flag_english.png",
                                              height: 24.h,
                                              width: 24.h,
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Text(
                                                "English",
                                                // LanguageController.language.languageName,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Radio<Language>(
                                              value: LanguageController.languages[1],
                                              // value: "English",
                                              groupValue: language,
                                              onChanged: (value) async {
                                                if (language != value) {
                                                  language = value!;
                                                  // await LanguageController.switchLanguage(context, language);
                                                  context.read<LanguageBloc>().add(ChangeLanguageAction(context: context, language: language));
                                                }
                                                setState1(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: SizedBox(
                              height: 24.h,
                              width: 24.h,
                              child: Icon(
                                Icons.language,
                                size: 24.h,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
