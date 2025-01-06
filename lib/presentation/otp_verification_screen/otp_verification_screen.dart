import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/otp_verification_screen/otp_validation_bloc/otp_validation_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final pinController1 = TextEditingController();
  final pinController2 = TextEditingController();
  final pinController3 = TextEditingController();
  final pinController4 = TextEditingController();
  final pinController5 = TextEditingController();
  final pinController6 = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();

  bool isLoadingActive = false;

  Widget pinField({
    TextEditingController? controller,
    FocusNode? focusNode,
    FocusNode? nextFocus,
  }) {
    return SizedBox(
      height: 55.h,
      width: 50.h,
      child: TextField(
        // scrollController: widget.scrollController,
        focusNode: focusNode,
        controller: controller,
        // autofocus: widget.autofocus,
        // textInputAction: widget.textInputAction,
        // obscureText: widget.obscureText,
        keyboardType: TextInputType.number,
        expands: true,
        maxLines: null,
        maxLength: 1,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        // // minLines: 1,
        style: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          // error: widget.error,
          // error: isError ? widget.error : null,
          filled: true,
          fillColor: AppColor.border,
          // fillColor: AppColor.shape_3,
          // suffixIcon: widget.suffixIcon,
          // prefixIcon: widget.prefixIcon,
          contentPadding: EdgeInsets.all(10.h),
          // hintText: widget.textFieldHintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          // border: widget.border ??
          //     OutlineInputBorder(
          //       borderSide: const BorderSide(
          //         width: 0,
          //         style: BorderStyle.none,
          //       ),
          //       borderRadius: widget.radius != null ? BorderRadius.circular(widget.radius!) : BorderRadius.circular(10),
          //     ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(10),
            // borderRadius: widget.radius != null ? BorderRadius.circular(widget.radius!) : BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            nextFocus != null ? FocusScope.of(context).requestFocus(nextFocus) : null;
          }
        },
        // readOnly: widget.readOnly,
        // onTap: () {
        //   if (widget.autofocus) {
        //     Scrollable.ensureVisible(
        //       widget.focusNode?.context ?? context,
        //       // context,
        //       alignment: 0.5,
        //       duration: const Duration(milliseconds: 100),
        //     );
        //   }
        //   widget.onTap?.call();
        // },
        // onSubmitted: widget.onSubmitted,
      ),
      // child: AppTextFieldWidget(
      //   textFieldTitle: "",
      //   textFieldHintText: "",
      //   // controller: newPasswordTextController,
      //   // textInputAction: TextInputAction.go,
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: AppBarWidget(
                title: 'OTP Verification',
                useLeading: false,
                onBack: () {
                  Get.back();
                },
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Container(
                  // color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.h + 280.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          pinField(
                            controller: pinController1,
                            focusNode: focusNode1,
                            nextFocus: focusNode2,
                          ),
                          SizedBox(width: 3.w),
                          pinField(
                            controller: pinController2,
                            focusNode: focusNode2,
                            nextFocus: focusNode3,
                          ),
                          SizedBox(width: 3.w),
                          pinField(
                            controller: pinController3,
                            focusNode: focusNode3,
                            nextFocus: focusNode4,
                          ),
                          SizedBox(width: 3.w),
                          pinField(
                            controller: pinController4,
                            focusNode: focusNode4,
                            nextFocus: focusNode5,
                          ),
                          SizedBox(width: 3.w),
                          pinField(
                            controller: pinController5,
                            focusNode: focusNode5,
                            nextFocus: focusNode6,
                          ),
                          SizedBox(width: 3.w),
                          pinField(
                            controller: pinController6,
                            focusNode: focusNode6,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      AppMainButtonWidget(
                        text: "Confirm OTP",
                        onPressed: () {
                          if (pinController1.text.isEmpty || pinController2.text.isEmpty || pinController3.text.isEmpty || pinController4.text.isEmpty || pinController5.text.isEmpty || pinController6.text.isEmpty) {
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
                            String otp = pinController1.text + pinController2.text + pinController3.text + pinController4.text + pinController5.text + pinController6.text;
                            AppLoggerCS.debugLog("otp: $otp");
                            context.read<OtpValidationBloc>().add(
                                  OtpValidationAction(
                                    otp: otp,
                                  ),
                                );
                            // AppDialogActionCS.showWarningPopup(
                            //   context: context,
                            //   title: "Cek Kembali",
                            //   description: "Apakah Anda yakin ingin mengganti password?",
                            //   mainButtonTitle: "Lanjut",
                            //   mainButtonAction: () {
                            //     FocusManager.instance.primaryFocus?.unfocus();
                            //     Get.back();
                            // context.read<OtpValidationBloc>().add(
                            //       OtpValidationAction(
                            //         otp: otp,
                            //       ),
                            //     );
                            //   },
                            //   secondaryButtonTitle: "Tidak Jadi",
                            //   secondaryButtonAction: () {
                            //     Get.back();
                            //   },
                            //   // reverseButton: true,
                            //   isHorizontal: false,
                            // );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          BlocListener<OtpValidationBloc, OtpValidationState>(
            listener: (context, state) {
              if (state is OtpValidationLoading) {
                isLoadingActive = true;
              } else {
                isLoadingActive = false;
                if (state is OtpValidationFailed) {
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
                if (state is OtpValidationSuccess) {
                  AppDialogActionCS.showSuccessPopup(
                    context: context,
                    title: "Sukses",
                    description: "Berhasil verifikasi akun, silakan login",
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
