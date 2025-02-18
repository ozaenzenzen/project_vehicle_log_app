import 'package:app_settings/app_settings.dart';
import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_open_app_settings/flutter_open_app_settings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.shape,
      appBar: AppBarWidget(
        title: 'Notification Settings',
        onBack: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 16.h,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                // setState(() {
                //   currentLanguage = language[index];
                // });
                // FlutterOpenAppSettings.openAppsSettings(
                //   settingsCode: SettingsCode.NOTIFICATION,
                //   onCompletion: () {
                //     AppLoggerCS.debugLog("value settings");
                //   },
                // );
                await AppSettings.openNotificationSettings();
              },
              child: Container(
                padding: EdgeInsets.all(16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Open Notification Settings",
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
            ),
          ],
        ),
      ),
    );
  }
}
