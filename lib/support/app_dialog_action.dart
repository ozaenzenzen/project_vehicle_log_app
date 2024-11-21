// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_container_box_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/support/app_assets.dart';

class AppDialogAction {
  static Future<void> showSuccessSignUp({
    required BuildContext context,
    required Function() mainButtonAction,
    double radius = 0,
    String title = "",
    String buttonTitle = "Tutup",
    Color? color,
    bool barrierDismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showPopup(
      context: context,
      radius: radius,
      color: color,
      content: Column(
        children: [
          Row(
            children: [
              (barrierDismissible)
                  ? InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: Icon(
                          Icons.arrow_back,
                          size: 20.h,
                          color: const Color(0xff26120F),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: 20.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xff26120F),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Image.asset(
          //   Assets.successSignUp,
          //   height: 150.h,
          // ),
          Icon(
            Icons.check,
            size: 150.h,
          ),
          SizedBox(height: 31.h),
          Text(
            "Sign Up Success",
            style: GoogleFonts.inter(
              color: const Color(0xff26120F),
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24.h),
          AppMainButtonWidget(
            onPressed: mainButtonAction,
            text: buttonTitle,
            fontSize: 14.sp,
            height: 40.h,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
  }

  static Future<void> showFreezeAppPopup({
    required BuildContext context,
    double radius = 20,
    String title = "",
    String buttonTitle = "Close App",
    Color? color,
    String contentTitle = "",
    String contentBody = "",
    bool barrierDismissible = true,
    bool useButtonBack = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showMainPopup(
      context: context,
      radius: radius,
      color: color,
      title: title,
      useButtonBack: useButtonBack,
      content: AppContainerBoxWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contentTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              contentBody,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      buttonTitle: buttonTitle,
      mainButtonAction: () {
        exit(0);
        // Get.back();
      },
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
  }

  static Future<void> showMainPopup({
    required BuildContext context,
    Function()? mainButtonAction,
    double radius = 0,
    String title = "",
    String buttonTitle = "",
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    bool useButtonBack = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double? buttonHeight,
    double? buttonTextSize,
  }) async {
    return await showPopup(
      context: context,
      radius: radius,
      color: color,
      content: Column(
        children: [
          Row(
            children: [
              useButtonBack
                  ? InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: Icon(
                          Icons.arrow_back,
                          size: 20.h,
                          color: const Color(0xff26120F),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: 20.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xff26120F),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          content ?? const SizedBox(),
          mainButtonAction == null
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    AppMainButtonWidget(
                      onPressed: mainButtonAction,
                      text: buttonTitle,
                      fontSize: buttonTextSize ?? 18.sp,
                      height: buttonHeight ?? 48.h,
                    ),
                  ],
                ),
        ],
      ),
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
  }

  static Future<void> showSecondaryPopup({
    required BuildContext context,
    double radius = 0,
    String title = "",
    String buttonTitle = "",
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    bool useButtonBack = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showPopup(
      context: context,
      radius: radius,
      color: color,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xff26120F),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              useButtonBack
                  ? InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: Icon(
                          Icons.close,
                          size: 20.h,
                          color: const Color(0xff26120F),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          SizedBox(height: 24.h),
          content ?? const SizedBox(),
        ],
      ),
      barrierDismissible: barrierDismissible,
      padding: padding,
    );
  }

  static Future<void> showPopup({
    required BuildContext context,
    double radius = 0,
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(barrierDismissible),
        child: Center(
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(30.h),
                padding: padding,
                // width: double.infinity,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: color ?? const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: content ?? const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showSuccessPopup({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonTitle,
    Function()? mainButtonAction,
    double radius = 10,
    double? buttonHeight,
    double? buttonTextSize,
    bool barrierDismissible = true,
  }) async {
    await showMainPopup(
      context: context,
      title: '',
      radius: radius,
      buttonHeight: buttonHeight,
      buttonTextSize: buttonTextSize,
      barrierDismissible: barrierDismissible,
      useButtonBack: false,
      content: Column(
        children: [
          Image.asset(
            AppAssets.iconPopupSuccess,
            height: 96.h,
            width: 96.h,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttonTitle: buttonTitle,
      mainButtonAction: mainButtonAction ??
          () {
            if (barrierDismissible) {
              Get.back();
            }
          },
    );
  }

  static Future<void> showFailedPopup({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonTitle,
    Function()? mainButtonAction,
    double radius = 10,
    double? buttonHeight,
    double? buttonTextSize,
    bool barrierDismissible = true,
  }) async {
    await showMainPopup(
      context: context,
      title: '',
      radius: radius,
      buttonHeight: buttonHeight,
      buttonTextSize: buttonTextSize,
      barrierDismissible: barrierDismissible,
      useButtonBack: false,
      content: Column(
        children: [
          Image.asset(
            AppAssets.iconPopupError,
            height: 96.h,
            width: 96.h,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttonTitle: buttonTitle,
      mainButtonAction: mainButtonAction ??
          () {
            if (barrierDismissible) {
              Get.back();
            }
          },
    );
  }

  static Future<void> showWarningPopup({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonTitle,
    Function()? mainButtonAction,
    double radius = 10,
    double? buttonHeight,
    double? buttonTextSize,
    bool barrierDismissible = true,
  }) async {
    await showMainPopup(
      context: context,
      title: '',
      radius: radius,
      buttonHeight: buttonHeight,
      buttonTextSize: buttonTextSize,
      barrierDismissible: barrierDismissible,
      useButtonBack: false,
      content: Column(
        children: [
          Image.asset(
            AppAssets.iconPopupWarning,
            height: 96.h,
            width: 96.h,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      buttonTitle: buttonTitle,
      mainButtonAction: mainButtonAction ??
          () {
            if (barrierDismissible) {
              Get.back();
            }
          },
    );
  }
}
