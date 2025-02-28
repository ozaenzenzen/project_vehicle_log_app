import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
          'Privacy Policy',
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
              'Kebijakan Privasi Qoin Service PT Qoin Digital Indonesia (“QOIN” atau “Kami”) selalu memprioritaskan kenyamanan dan keamanan data pengguna. Pada kebijakan privasi ini akan dijelaskan secara transparan bagaimana cara Qoin service mengumpulkan, mendapatkan, menyimpan, mengolah, menampilkan, dan menggunakan data pribadi Anda. Dengan menggunakan Qoin Service maka Anda mengakui bahwa Anda telah membaca, memahami dan menyetujui seluruh ketentuan yang terdapat pada kebijakan privasi, dan merupakan satu kesatuan dengan Ketentuan Layanan Qoin Service.',
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'A. Data Pribadi',
              style: GoogleFonts.lato(
                color: const Color(0xff0A0A0A),
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              """
Situs Qoin Service disediakan gratis bagi pengguna yang sudah terdaftar. Siapa pun dapat mendaftar untuk memiliki akun pada situs  Qoin Service. Data pribadi termasuk tetapi tidak terbatas pada nama, nomor handphone, email, data identitas (KTP), dan data yang menyangkut informasi mengenai kegiatan transaksi pada situs Qoin Service.
""",
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'B. Perolehan dan Pengumpulan Data Pribadi',
              style: GoogleFonts.lato(
                color: const Color(0xff0A0A0A),
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              """
Situs Qoin Service  akan mengumpulkan data pribadi dari pengguna pada setiap saat namun tidak terbatas pada saat membuat akun, melakukan upgrade akun, dan melakukan transaksi di dalam situs Qoin Service. Data pribadi yang dikumpulkan di antaranya data sehubungan dengan:
1. Informasi yang didapatkan pengguna (secara langsung atau tidak langsung) ketika mendaftar/membuat akun Qoin Service termasuk nama, nomor handphone, email, data identitas (KTP) untuk upgrade akun QOIN (“Informasi Pendaftaran”).
2. Informasi yang didapatkan (secara langsung atau tidak langsung) selama pengguna menggunakan situs Qoin Service, termasuk nomor rekening bank pengguna, informasi tagihan, pengiriman, dan data transaksi (“Informasi Rekening”)
""",
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
