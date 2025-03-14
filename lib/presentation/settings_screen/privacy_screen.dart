import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/support/app_readjson.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Map<String, dynamic>? dataTnC;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dataTnC = await AppReadJsonHelper().readJson(asset: "assets/privacypolicy.json");
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
          LanguageController.language.privacyAndPolicy,
          // 'Privacy Policy',
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
              'Kami di App Vehicle Log menghargai privasi Anda dan berkomitmen untuk melindungi informasi pribadi Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi data pengguna.',
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
                List<String> listString = (dataMapping['details'] as List).map((element) => element.toString()).toList();
                String letter = String.fromCharCode(65 + index); // Convert index (0 → 'A', 1 → 'B', ...)

                return detailsItem(
                  title: "$letter. ${dataMapping['title']}",
                  description: listString,
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

  Widget detailsItemOld({
    required String title,
    required String description,
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
          description,
//           """
// Kami dapat mengumpulkan informasi berikut
// 1. Informasi pribadi (nama, alamat email, nomor telepon, dll.)
// 2. Informasi penggunaan aplikasi (aktivitas, preferensi, dll.)
// 3. Data perangkat (model perangkat, sistem operasi, dll.)
// """,
          style: GoogleFonts.lato(
            color: const Color(0xff616161),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
