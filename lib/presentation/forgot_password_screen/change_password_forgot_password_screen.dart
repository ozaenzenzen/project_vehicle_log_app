import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/change_password_forgot_password_bloc/change_password_forgot_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';

class ChangePasswordForgotPasswordScreen extends StatefulWidget {
  const ChangePasswordForgotPasswordScreen({super.key});

  @override
  State<ChangePasswordForgotPasswordScreen> createState() => _ChangePasswordForgotPasswordScreenState();
}

class _ChangePasswordForgotPasswordScreenState extends State<ChangePasswordForgotPasswordScreen> {
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmNewPasswordTextController = TextEditingController();

  bool isHideNewPassword = true;
  bool isHideConfirmNewPassword = true;

  bool isLoadingActive = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // return true;
        return false;
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: const AppBarWidget(
                title: "Change Password Forgot Password",
                useLeading: false,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    AppTextFieldWidget(
                      textFieldTitle: "New Password",
                      textFieldHintText: "New Password",
                      controller: newPasswordTextController,
                      obscureText: isHideNewPassword,
                      textInputAction: TextInputAction.go,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isHideNewPassword = !isHideNewPassword;
                          });
                        },
                        child: Icon(
                          isHideNewPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      // onSubmitted: (String value) {
                      //   context.read<SigninBloc>().add(
                      //         SigninAction(
                      //           signInRequestModel: SignInRequestModel(
                      //             email: emailTextFieldController.text,
                      //             password: passwordTextFieldController.text,
                      //           ),
                      //         ),
                      //       );
                      // },
                    ),
                    SizedBox(height: 16.h),
                    AppTextFieldWidget(
                      textFieldTitle: "Confirm New Password",
                      textFieldHintText: "Confirm New Password",
                      controller: confirmNewPasswordTextController,
                      obscureText: isHideConfirmNewPassword,
                      textInputAction: TextInputAction.go,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isHideConfirmNewPassword = !isHideConfirmNewPassword;
                          });
                        },
                        child: Icon(
                          isHideConfirmNewPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      // onSubmitted: (String value) {
                      //   context.read<SigninBloc>().add(
                      //         SigninAction(
                      //           signInRequestModel: SignInRequestModel(
                      //             email: emailTextFieldController.text,
                      //             password: passwordTextFieldController.text,
                      //           ),
                      //         ),
                      //       );
                      // },
                    ),
                    SizedBox(height: 20.h),
                    AppMainButtonWidget(
                      onPressed: () {
                        if (newPasswordTextController.text.isEmpty || confirmNewPasswordTextController.text.isEmpty) {
                          AppDialogActionCS.showFailedPopup(
                            context: context,
                            title: "Terjadi kesalahan",
                            description: "Data tidak lengkap",
                            buttonTitle: "Kembali",
                            mainButtonAction: () {
                              Get.back();
                            },
                          );
                        } else {
                          AppDialogActionCS.showWarningPopup(
                            context: context,
                            title: "Cek Kembali",
                            description: "Apakah Anda yakin ingin mengganti password?",
                            mainButtonTitle: "Lanjut",
                            mainButtonAction: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.back();
                              context.read<ChangePasswordForgotPasswordBloc>().add(
                                    ChangePasswordForgotPasswordAction(
                                      newPassword: newPasswordTextController.text,
                                      confirmNewPassword: confirmNewPasswordTextController.text,
                                    ),
                                  );
                            },
                            secondaryButtonTitle: "Tidak Jadi",
                            secondaryButtonAction: () {
                              Get.back();
                            },
                            // reverseButton: true,
                            isHorizontal: false,
                          );
                        }
                      },
                      text: "Update Password",
                    ),
                  ],
                ),
              ),
            ),
          ),
          BlocListener<ChangePasswordForgotPasswordBloc, ChangePasswordForgotPasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordForgotPasswordLoading) {
                isLoadingActive = true;
              } else {
                isLoadingActive = false;
                if (state is ChangePasswordForgotPasswordFailed) {
                  AppDialogActionCS.showFailedPopup(
                    context: context,
                    title: "Terjadi kesalahan",
                    description: state.errorMessage,
                    buttonTitle: "Kembali",
                    mainButtonAction: () {
                      Get.back();
                    },
                  );
                }
                if (state is ChangePasswordForgotPasswordSuccess) {
                  AppDialogActionCS.showSuccessPopup(
                    context: context,
                    title: "Sukses",
                    description: "Berhasil ganti password",
                    buttonTitle: "Lanjut",
                    mainButtonAction: () {
                      Get.offAll(() => const SignInPage());
                    },
                  );
                }
              }
              setState(() {});
            },
            child: (isLoadingActive) ? const AppOverlayLoading2Widget() : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
