import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';
import 'package:project_vehicle_log_app/support/config/language/language.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

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
    return Scaffold(
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
                        LanguageController.switchLanguage(currentLanguage);
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
    );
  }
}
