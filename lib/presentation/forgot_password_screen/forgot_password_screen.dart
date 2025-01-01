import 'package:fam_coding_supply/ui/widget/app_mainbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // backgroundColor: AppColor.shape,
        appBar: AppBarWidget(
          title: "Forgot Password",
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
              SizedBox(height: 16.h),
              AppTextFieldWidget(
                textFieldTitle: "Your Email",
                textFieldHintText: "youremail@domain.com",
                controller: emailTextController,
                // textInputAction: TextInputAction.go,
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
                      "Already Have OTP Forgot Password?",
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
              AppMainButtonWidget(
                onPressed: () {
                  // if (oldPasswordTextController.text.isEmpty || newPasswordTextController.text.isEmpty || confirmNewPasswordTextController.text.isEmpty) {
                  //   AppDialogActionCS.showFailedPopup(
                  //     context: context,
                  //     title: "Terjadi kesalahan",
                  //     description: "Data tidak lengkap",
                  //     buttonTitle: "Kembali",
                  //     mainButtonAction: () {
                  //       Get.back();
                  //     },
                  //   );
                  // } else {
                  //   AppDialogActionCS.showWarningPopup(
                  //     context: context,
                  //     title: "Cek Kembali",
                  //     description: "Apakah Anda yakin ingin mengganti password?",
                  //     mainButtonTitle: "Lanjut",
                  //     mainButtonAction: () {
                  //       FocusManager.instance.primaryFocus?.unfocus();
                  //       Get.back();
                  //       context.read<ChangePasswordBloc>().add(
                  //             ChangePasswordAction(
                  //               reqData: ChangePasswordRequestModel(
                  //                 oldPassword: oldPasswordTextController.text,
                  //                 newPassword: newPasswordTextController.text,
                  //                 confirmNewPassword: confirmNewPasswordTextController.text,
                  //               ),
                  //             ),
                  //           );
                  //     },
                  //     secondaryButtonTitle: "Tidak Jadi",
                  //     secondaryButtonAction: () {
                  //       Get.back();
                  //     },
                  //     // reverseButton: true,
                  //     isHorizontal: false,
                  //   );
                  // }
                },
                text: "Send OTP Forgot Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
