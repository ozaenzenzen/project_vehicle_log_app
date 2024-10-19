import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signup_request_models.dart';
import 'package:project_vehicle_log_app/presentation/signin/signin_page.dart';
import 'package:project_vehicle_log_app/presentation/signup/signup_bloc/signup_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_loading_indicator.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_dialog_action.dart';
import 'package:project_vehicle_log_app/support/app_info.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

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
                  height: MediaQuery.of(context).size.height,
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
                        "Daftar Akun",
                        style: AppTheme.theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // SizedBox(height: 20.h),
                    SizedBox(height: 50.h),
                    AppTextFieldWidget(
                      textFieldTitle: "Nama",
                      textFieldHintText: "example",
                      controller: nameTextFieldController,
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: "Email",
                      textFieldHintText: "journalist@email.com",
                      controller: emailTextFieldController,
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: "Phone",
                      textFieldHintText: "0888-8888-8888",
                      controller: phoneTextFieldController,
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: "Password",
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
                        )
                      ),
                    ),
                    SizedBox(height: 10.h),
                    AppTextFieldWidget(
                      textFieldTitle: "Confirm Password",
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
                        )
                      ),
                    ),
                    SizedBox(height: 20.h),
                    BlocConsumer<SignupBloc, SignupState>(
                      listener: (context, state) {
                        if (state is SignupFailed) {
                          AppDialogAction.showPopup(
                            content: Column(
                              children: [
                                Icon(
                                  Icons.close,
                                  color: AppColor.error,
                                  size: 80.h,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  "Error",
                                  style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                                    // color: AppColor.text_4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  state.errorMessage,
                                  style: AppTheme.theme.textTheme.titleLarge?.copyWith(
                                    // color: AppColor.text_4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            context: context,
                          );
                        } else if (state is SignupSuccess) {
                          AppDialogAction.showSuccessPopup(
                            context: context,
                            title: "Success",
                            description: "Berhasil mendaftarkan akun. Silakan login",
                            buttonTitle: "Login",
                            mainButtonAction: () {
                              Get.offAll(
                                () => const SignInPage(),
                              );
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
                              onPressed: () {
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
                              },
                              text: "Daftar",
                            ),
                            SizedBox(height: 20.h),
                            const Text("Sudah Ada Akun?"),
                            SizedBox(height: 20.h),
                            AppMainButtonWidget(
                              onPressed: () {
                                Get.back();
                                // Get.to(
                                //   () => const MainPage(),
                                // );
                              },
                              text: "Masuk",
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
