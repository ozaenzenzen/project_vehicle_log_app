import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/data/dummy_data_profile.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class SecurityPreferencesScreen extends StatefulWidget {
  const SecurityPreferencesScreen({super.key});

  @override
  State<SecurityPreferencesScreen> createState() => _SecurityPreferencesScreenState();
}

class _SecurityPreferencesScreenState extends State<SecurityPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      appBar: AppBarWidget(
        // title: 'Security Preferences',
        title: LanguageController.language.securityPreferences,
        onBack: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Apps",
              //     style: AppTheme.theme.textTheme.headlineSmall?.copyWith(
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10.h),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  // itemCount: 5,
                  itemCount: ProfileMenuSettings.securityPrefrerencesMenuItem.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ProfileMenuSettings.securityPrefrerencesMenuItem[index].menuFunction?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // "menus $index",
                              "${ProfileMenuSettings.securityPrefrerencesMenuItem[index].menuTitle}",
                              style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 20.h,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1.h,
                      color: Colors.black26,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
