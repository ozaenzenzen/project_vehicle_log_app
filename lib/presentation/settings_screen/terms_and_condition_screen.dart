import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/support/app_readjson.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  Map<String, dynamic>? dataTnC;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dataTnC = await AppReadJsonHelper().readJson(asset: "assets/termsandcondition.json");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7F7),
        surfaceTintColor: const Color(0xffF7F7F7),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.h,
          ),
        ),
        title: Text(
          LanguageController.language.termsAndConditions,
          // 'Terms & Condition',
          style: GoogleFonts.lato(
            color: const Color(0xff1A1C1E),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text(
              "${dataTnC?['introduction']}",
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (dataTnC != null) ? dataTnC!['data'].length : 0,
              itemBuilder: (context, index) {
                var dataMapping = dataTnC!['data'][index];
                // AppLoggerCS.debugLog("${dataMapping['details']}");
                List<String> listString = (dataMapping['details'] as List).map((element) => element.toString()).toList();
                String letter = String.fromCharCode(65 + index); // Convert index (0 → 'A', 1 → 'B', ...)

                return detailsItem(
                  title: "$letter. ${dataMapping['title']}",
                  // title: "${index + 1}. ${dataMapping['title']}",
                  description: listString,
                  // description: dataMapping['details'] as List<String>,
                  // description: "${}",
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8.h);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget detailsItem({
    required String title,
    required List<String> description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // "A. Informasi yang Kami Kumpulkan",
          style: GoogleFonts.lato(
            color: const Color(0xff0A0A0A),
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          description.asMap().entries.map((entry) {
            int num = entry.key + 1;
            return (description.length < 2) ? entry.value : "$num. ${entry.value}";
          }).join("\n"),
          style: GoogleFonts.lato(
            color: const Color(0xff616161),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
