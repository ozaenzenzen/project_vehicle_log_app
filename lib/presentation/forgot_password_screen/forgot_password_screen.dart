import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/ui/widget/app_loading_indicator.dart';
import 'package:fam_coding_supply/ui/widget/app_mainbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/change_password_forgot_password_screen.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/send_otp_forgot_password_bloc/send_otp_forgot_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/forgot_password_screen/validate_otp_forgot_password_bloc/validate_otp_forgot_password_bloc.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_textfield_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController otpInputController = TextEditingController();

  bool isLoadingActive = false;

  bool isLoadingValidateOtp = false;

  @override
  void initState() {
    emailTextController.text = "recovery252@gmail.com";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
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
                          // AppLoggerCS.debugLog("check");
                          // Get.to(() => const ForgotPasswordScreen());
                          // AppDialogActionCS.showWarningPopup(
                          //   context: context,
                          //   title: "title",
                          //   description: "description",
                          // );
                          popupValidateOtp();
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
                      if (emailTextController.text.isEmpty) {
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
                        AppDialogActionCS.showWarningPopup(
                          context: context,
                          title: "Cek Kembali",
                          description: "Apakah Anda yakin ingin mengirim OTP?",
                          mainButtonTitle: "Lanjut",
                          mainButtonAction: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.back();
                            context.read<SendOtpForgotPasswordBloc>().add(
                                  SendOTPForgotPasswordAction(
                                    email: emailTextController.text,
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
                    text: "Send OTP Forgot Password",
                  ),
                ],
              ),
            ),
          ),
        ),
        BlocListener<SendOtpForgotPasswordBloc, SendOtpForgotPasswordState>(
          listener: (context, state) {
            if (state is SendOtpForgotPasswordLoading) {
              isLoadingActive = true;
            } else {
              isLoadingActive = false;
              if (state is SendOtpForgotPasswordFailed) {
                AppDialogActionCS.showFailedPopup(
                  context: context,
                  title: LanguageController.language.errorTitle1,
                  description: state.errorMessage,
                  buttonTitle: LanguageController.language.backButton,
                  mainButtonAction: () {
                    Get.back();
                  },
                );
              }
              if (state is SendOtpForgotPasswordSuccess) {
                AppDialogActionCS.showSuccessPopup(
                  context: context,
                  title: "Sukses",
                  description: "Cek OTP pada email Anda",
                  buttonTitle: LanguageController.language.backButton,
                  mainButtonAction: () {
                    emailTextController.clear();
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

  bool validateOtpBarrierDismissible = true;

  void popupValidateOtp() {
    isLoadingValidateOtp = false;

    AppDialogActionCS.showMainPopup(
      context: context,
      // barrierDismissible: false,
      barrierDismissible: validateOtpBarrierDismissible,
      content: StatefulBuilder(
        builder: (context, setState1) {
          return Column(
            children: [
              Text(
                "Input your OTP Here",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              AppTextFieldWidget(
                controller: otpInputController,
                textFieldTitle: "",
                textFieldHintText: "ex: 190190",
                maxLength: 6,
              ),
              SizedBox(height: 20.h),
              BlocListener<ValidateOtpForgotPasswordBloc, ValidateOtpForgotPasswordState>(
                listener: (context, state) {
                  AppLoggerCS.debugLog("state now: $state");
                  if (state is ValidateOtpForgotPasswordLoading) {
                    isLoadingValidateOtp = true;
                  } else {
                    isLoadingValidateOtp = false;
                    if (state is ValidateOtpForgotPasswordFailed) {
                      AppDialogActionCS.showFailedPopup(
                        context: context,
                        title: LanguageController.language.errorTitle1,
                        description: state.errorMessage,
                        buttonTitle: LanguageController.language.backButton,
                        mainButtonAction: () {
                          Get.back();
                        },
                      );
                    }
                    if (state is ValidateOtpForgotPasswordSuccess) {
                      validateOtpBarrierDismissible = false;
                      AppDialogActionCS.showSuccessPopup(
                        context: context,
                        title: "Sukses",
                        description: "Silakan lanjutkan untuk mengganti password",
                        buttonTitle: "Lanjut",
                        barrierDismissible: validateOtpBarrierDismissible,
                        mainButtonAction: () {
                          otpInputController.clear();
                          Get.back();
                          Get.off(() => const ChangePasswordForgotPasswordScreen());
                        },
                      );
                    }
                  }
                  setState1(() {});
                },
                child: !isLoadingValidateOtp
                    ? AppMainButtonWidget(
                        onPressed: () {
                          // setState1(() {
                          //   isLoadingValidateOtp = !isLoadingValidateOtp;
                          // });
                          AppLoggerCS.debugLog('isLoadingValidateOtp $isLoadingValidateOtp');
                          context.read<ValidateOtpForgotPasswordBloc>().add(
                                ValidateOTPForgotPasswordAction(
                                  otp: otpInputController.text,
                                ),
                              );
                        },
                        text: "Confirm",
                      )
                    : const AppLoadingIndicator(),
              ),
              // !isLoadingValidateOtp
              //     ? AppMainButtonWidget(
              //         onPressed: () {
              //           setState1(() {
              //             isLoadingValidateOtp = !isLoadingValidateOtp;
              //           });
              //           AppLoggerCS.debugLog('isLoadingValidateOtp $isLoadingValidateOtp');
              //           // Get.back();
              //           // Get.off(() => const ChangePasswordForgotPasswordScreen());
              //           // context.read<ValidateOtpForgotPasswordBloc>().add(
              //           //       ValidateOTPForgotPasswordAction(
              //           //         otp: otpInputController.text,
              //           //       ),
              //           //     );
              //         },
              //         text: "Confirm",
              //       )
              //     : const AppLoadingIndicator(),
            ],
          );
        },
      ),
    );
  }
}
