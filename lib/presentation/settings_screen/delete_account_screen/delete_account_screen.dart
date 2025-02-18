import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/ui/widget/app_mainbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.shape,
        appBar: AppBarWidget(
          title: 'Delete Account',
          onBack: () {
            Get.back();
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.h,
          ),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Center(
                child: CircleAvatar(
                  radius: 70.h,
                  backgroundColor: AppColor.primary,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 67.h,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Delete Account",
                style: GoogleFonts.inter(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Warning! ',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.red,
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "This will permanent and cannot be undone! Your account will be deactivated in 30 days before it permanently deleted.\nYou can contact Customer Service for activation",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.red,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: reasonController,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "Any reason you want to share",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.h),
              AppMainButtonWidget(
                onPressed: () async {
                  await AppDialogActionCS.showWarningPopup(
                    context: context,
                    title: "Delete Account",
                    isHorizontal: false,
                    reverseButton: true,
                    description: "Are you sure you want to delete the account?",
                    mainButtonAction: () {
                      Get.back();
                    },
                    mainButtonTitle: "Cancel",
                    secondaryButtonAction: () {
                      //
                    },
                    secondaryButtonTitle: "Delete",
                  );
                },
                text: "Delete Account",
              ),
              // Text(
              //   "Warning! This is permanent and cannot be undone!",
              //   textAlign: TextAlign.center,
              //   style: GoogleFonts.inter(
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w500,
              //     color: AppColor.red,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
