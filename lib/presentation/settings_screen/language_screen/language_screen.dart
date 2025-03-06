import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language.dart';
import 'package:project_vehicle_log_app/support/config/language/language_bloc/language_bloc.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';
import 'package:restart_app/restart_app.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // List<String> language = <String>['Bahasa', 'English'];
  // String currentLanguage = 'English';
  Language currentLanguage = LanguageController.language;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.shape,
        appBar: AppBarWidget(
          title: LanguageController.language.language,
          // title: 'Language',
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
                  itemCount: LanguageController.languages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentLanguage = LanguageController.languages[index];
                          // LanguageController.switchLanguage(context, currentLanguage);
                          context.read<LanguageBloc>().add(ChangeLanguageAction(context: context, language: currentLanguage));
                          Restart.restartApp(
                            /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
                            // webOrigin: 'http://example.com',

                            // Customizing the restart notification message (only needed on iOS)
                            notificationTitle: 'Restarting App',
                            notificationBody: 'Please tap here to open the app again.',
                          );
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageController.languages[index].languageName,
                              style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Radio<Language>(
                              // Radio<String>(
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: LanguageController.languages[index],
                              groupValue: currentLanguage,
                              onChanged: (Language? value) {
                                // onChanged: (String? value) {
                                setState(() {
                                  currentLanguage = value!;
                                  context.read<LanguageBloc>().add(ChangeLanguageAction(context: context, language: currentLanguage));
                                  Restart.restartApp(
                                    /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
                                    // webOrigin: 'http://example.com',

                                    // Customizing the restart notification message (only needed on iOS)
                                    notificationTitle: 'Restarting App',
                                    notificationBody: 'Please tap here to open the app again.',
                                  );
                                });
                              },
                            ),
                            // Icon(
                            //   Icons.arrow_forward_ios_outlined,
                            //   size: 20.h,
                            // ),
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
