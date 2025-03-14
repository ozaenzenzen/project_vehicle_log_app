import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/ui/widget/app_mainbutton_widget.dart';
import 'package:fam_coding_supply/ui/widget/app_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/change_password_request_model.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/change_password_screen/change_password_bloc/change_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
// import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmNewPasswordTextController = TextEditingController();

  bool isHideOldPassword = true;
  bool isHideNewPassword = true;
  bool isHideConfirmNewPassword = true;

  bool isLoadingActive = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: AppColor.shape,
            appBar: AppBarWidget(
              title: 'Change Password',
              onBack: () {
                Get.back();
              },
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  AppTextFieldWidget(
                    textFieldTitle: LanguageController.language.oldPassword,
                    textFieldHintText: LanguageController.language.oldPassword,
                    // textFieldTitle: "Old Password",
                    // textFieldHintText: "Old Password",
                    controller: oldPasswordTextController,
                    obscureText: isHideOldPassword,
                    textInputAction: TextInputAction.go,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          isHideOldPassword = !isHideOldPassword;
                        });
                      },
                      child: Icon(
                        isHideOldPassword ? Icons.visibility_off : Icons.visibility,
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
                    textFieldTitle: LanguageController.language.newPassword,
                    textFieldHintText: LanguageController.language.newPassword,
                    // textFieldTitle: "New Password",
                    // textFieldHintText: "New Password",
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
                    textFieldTitle: LanguageController.language.confirmNewPassword,
                    textFieldHintText: LanguageController.language.confirmNewPassword,
                    // textFieldTitle: "Confirm New Password",
                    // textFieldHintText: "Confirm New Password",
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
                      if (oldPasswordTextController.text.isEmpty || newPasswordTextController.text.isEmpty || confirmNewPasswordTextController.text.isEmpty) {
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
                            context.read<ChangePasswordBloc>().add(
                                  ChangePasswordAction(
                                    reqData: ChangePasswordRequestModel(
                                      oldPassword: oldPasswordTextController.text,
                                      newPassword: newPasswordTextController.text,
                                      confirmNewPassword: confirmNewPasswordTextController.text,
                                    ),
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
                    text: "Change Password",
                  ),
                ],
              ),
            ),
          ),
        ),
        BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordLoading) {
              isLoadingActive = true;
            } else {
              isLoadingActive = false;
              if (state is ChangePasswordFailed) {
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
              if (state is ChangePasswordSuccess) {
                AppDialogActionCS.showSuccessPopup(
                  context: context,
                  title: "Sukses",
                  description: "Berhasil ganti password",
                  buttonTitle: "Kembali",
                  mainButtonAction: () {
                    Get.back();
                  },
                );
              }
            }
            setState(() {});
          },
          child: (isLoadingActive) ? const AppOverlayLoading2Widget() : const SizedBox(),
        ),
      ],
    );
  }
}
