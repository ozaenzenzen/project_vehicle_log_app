import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/ui/widget/app_mainbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/profile_screen/signout_bloc/signout_bloc.dart';
import 'package:project_vehicle_log_app/presentation/settings_screen/delete_account_screen/delete_account_bloc/delete_account_bloc.dart';
import 'package:project_vehicle_log_app/presentation/signin_screen/signin_page.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_overlay_loading2_widget.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  TextEditingController reasonTextController = TextEditingController();
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
              // title: 'Delete Account',
              title: LanguageController.language.deleteAccount,
              onBack: () {
                Get.back();
              },
            ),
            body: bodySection(context),
          ),
        ),
        MultiBlocListener(
          listeners: [
            BlocListener<DeleteAccountBloc, DeleteAccountState>(
              listener: (context, state) {
                if (state is DeleteAccountLoading) {
                  isLoadingActive = true;
                } else {
                  isLoadingActive = false;
                  if (state is DeleteAccountFailed) {
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
                  if (state is DeleteAccountSuccess) {
                    AppDialogActionCS.showSuccessPopup(
                      context: context,
                      title: "Success",
                      description: "${state.response.message}",
                      buttonTitle: "Signout",
                      barrierDismissible: false,
                      mainButtonAction: () {
                        Get.back();
                        context.read<SignoutBloc>().add(SignoutAction());
                      },
                    );
                  }
                }
                setState(() {});
              },
            ),
            BlocListener<SignoutBloc, SignoutState>(
              listener: (context, state) {
                if (state is SignoutFailed) {
                  AppDialogActionCS.showMainPopup(
                    context: context,
                    title: "Error",
                    content: Text(state.errorMessage),
                    mainButtonAction: () {
                      Get.back();
                    },
                  );
                } else if (state is SignoutSuccess) {
                  Get.offAll(() => const SignInPage());
                }
              },
            ),
          ],
          child: (isLoadingActive) ? const AppOverlayLoading2Widget() : const SizedBox(),
        ),
      ],
    );
  }

  Widget bodySection(BuildContext context) {
    return SingleChildScrollView(
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
            // "Delete Account",
            LanguageController.language.deleteAccount,
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              // text: 'Warning! ',
              text: "${LanguageController.language.warning}! ",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.red,
              ),
              children: <InlineSpan>[
                TextSpan(
                  // text: "This will permanent and cannot be undone! Your account will be deactivated in 30 days before it permanently deleted.\nYou can contact Customer Service for activation",
                  text: LanguageController.language.infoDeleteAccountDescription,
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
            controller: reasonTextController,
            maxLines: 10,
            decoration: InputDecoration(
              // hintText: "Any reason you want to share",
              hintText: LanguageController.language.reason,
              hintStyle: GoogleFonts.inter(
                color: Colors.black87,
                fontSize: 14.sp,
              ),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff616161),
                  width: 0.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          AppMainButtonWidget(
            onPressed: () async {
              await AppDialogActionCS.showWarningPopup(
                context: context,
                // title: "Delete Account",
                title: LanguageController.language.deleteAccount,
                isHorizontal: false,
                reverseButton: true,
                description: "Are you sure you want to delete the account?",
                mainButtonAction: () {
                  Get.back();
                },
                mainButtonTitle: "Cancel",
                secondaryButtonAction: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                  context.read<DeleteAccountBloc>().add(
                        DeleteAccountAction(
                          reason: reasonTextController.text.isEmpty ? "" : reasonTextController.text,
                        ),
                      );
                },
                secondaryButtonTitle: "Delete",
              );
            },
            // text: "Delete Account",
            text: LanguageController.language.deleteAccount,
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
    );
  }
}
