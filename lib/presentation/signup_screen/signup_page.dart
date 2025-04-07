import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signup_request_models.dart';
import 'package:project_vehicle_log_app/presentation/otp_verification_screen/otp_verification_screen.dart';
import 'package:project_vehicle_log_app/presentation/signup_screen/signup_bloc/signup_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameTextFieldController = TextEditingController(text: "");
  TextEditingController emailTextFieldController = TextEditingController(text: "");
  TextEditingController passwordTextFieldController = TextEditingController(text: "");
  TextEditingController confirmPasswordTextFieldController = TextEditingController(text: "");
  TextEditingController phoneTextFieldController = TextEditingController(text: "");

  bool isHidePassword = true;
  bool isHideConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // nameTextFieldController.text = "Akun Test OTP Register";
    // emailTextFieldController.text = "tkdbintara@gmail.com";
    // phoneTextFieldController.text = "080811110808";
    // passwordTextFieldController.text = "example";
    // confirmPasswordTextFieldController.text = "example";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.h),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 30.h,
                  child: Align(
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
                        }),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Spacer(),
                    SizedBox(height: 100.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        LanguageController.language.registerAccount,
                        // "Daftar Akun",
                        style: AppTheme.theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // SizedBox(height: 20.h),
                    SizedBox(height: 50.h),
                    AppTextFieldWidget(
                      textFieldTitle: LanguageController.language.registerName,
                      // textFieldTitle: "Nama",
                      textFieldHintText: "example",
                      controller: nameTextFieldController,
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: LanguageController.language.email,
                      // textFieldTitle: "Email",
                      // textFieldHintText: "Your Email Here",
                      textFieldHintText: LanguageController.language.emailHintText,
                      controller: emailTextFieldController,
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: LanguageController.language.registerPhone,
                      // textFieldTitle: "Phone",
                      textFieldHintText: "0888-8888-8888",
                      controller: phoneTextFieldController,
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: LanguageController.language.registerPassword,
                      // textFieldTitle: "Password",
                      textFieldHintText: "*****",
                      controller: passwordTextFieldController,
                      obscureText: isHidePassword,
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHidePassword = !isHidePassword;
                            });
                          },
                          child: Icon(
                            isHidePassword ? Icons.visibility_off : Icons.visibility,
                          )),
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: LanguageController.language.registerConfirmPassword,
                      // textFieldTitle: "Confirm Password",
                      textFieldHintText: "*****",
                      controller: confirmPasswordTextFieldController,
                      obscureText: isHideConfirmPassword,
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHideConfirmPassword = !isHideConfirmPassword;
                            });
                          },
                          child: Icon(
                            isHideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          )),
                    ),
                    SizedBox(height: 20.h),
                    BlocConsumer<SignupBloc, SignupState>(
                      listener: (context, state) {
                        if (state is SignupFailed) {
                          AppDialogActionCS.showFailedPopup(
                            context: context,
                            title: LanguageController.language.errorTitle1,
                            description: state.errorMessage,
                            // description: "Berhasil mendaftarkan akun. Silakan login",
                            buttonTitle: LanguageController.language.backButton,
                            mainButtonAction: () {
                              Get.back();
                            },
                          );
                        } else if (state is SignupSuccess) {
                          AppDialogActionCS.showSuccessPopup(
                            context: context,
                            title: "Success",
                            description: "Berhasil mendaftarkan akun. Silakan verifikasi OTP",
                            buttonTitle: "Lanjutkan",
                            mainButtonAction: () {
                              // Get.offAll(
                              //   () => const SignInPage(),
                              // );
                              Get.offAll(() => const OTPVerificationScreen());
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SignupLoading) {
                          return const AppLoadingIndicator();
                        }
                        return Column(
                          children: [
                            AppMainButtonWidget(
                              text: LanguageController.language.register,
                              // text: "Daftar",
                              onPressed: () {
                                if (nameTextFieldController.text.isEmpty ||
                                    emailTextFieldController.text.isEmpty ||
                                    phoneTextFieldController.text.isEmpty ||
                                    passwordTextFieldController.text.isEmpty ||
                                    confirmPasswordTextFieldController.text.isEmpty) {
                                  AppDialogActionCS.showFailedPopup(
                                    context: context,
                                    title: LanguageController.language.errorTitle1,
                                    description: "Data tidak lengkap",
                                    buttonTitle: LanguageController.language.backButton,
                                    mainButtonAction: () {
                                      Get.back();
                                    },
                                  );
                                } else {
                                  context.read<SignupBloc>().add(
                                        SignupAction(
                                          signUpRequestModel: SignUpRequestModel(
                                            name: nameTextFieldController.text,
                                            email: emailTextFieldController.text,
                                            phone: phoneTextFieldController.text,
                                            password: passwordTextFieldController.text,
                                            confirmPassword: confirmPasswordTextFieldController.text,
                                          ),
                                        ),
                                      );
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              LanguageController.language.alreadyHaveAnAccount,
                              // "Sudah Ada Akun?",
                            ),
                            SizedBox(height: 20.h),
                            AppMainButtonWidget(
                              onPressed: () {
                                Get.back();
                                // Get.to(
                                //   () => const MainPage(),
                                // );
                              },
                              text: LanguageController.language.login,
                              // text: "Masuk",
                            ),
                            SizedBox(height: 20.h),
                          ],
                        );
                      },
                    ),
                    // const Spacer(),
                    // FutureBuilder(
                    //   future: AppInfo.showAppVersion(),
                    //   builder: (context, snapshot) {
                    //     return Text(
                    //       // "Vehicle Log Apps Version 1.0.0+1",
                    //       // "Vehicle Log Apps Version ${AppInfo.appVersion}",
                    //       "Vehicle Log Apps Version ${snapshot.data}",
                    //       style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                    //         fontSize: 10.sp,
                    //         color: Colors.grey,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
