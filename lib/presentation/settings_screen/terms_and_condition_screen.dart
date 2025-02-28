import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
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
          'Terms & Condition',
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
              'Ketentuan Layanan yang ditetapkan dibawah ini mengatur pemakaian layanan yang ditawarkan oleh PT Qoin Digital Indonesia (“QOIN” atau “Kami”). Sebelum menggunakan layanan Qoin Service pengguna diwajibkan untuk membaca keseluruhan Ketentuan Layanan Qoin Service. Jika memiliki pertanyaan pengguna dapat menghubungi customer care Qoin Service. Ketentuan Layanan ini mengatur pengguna serta akses pengguna terhadap website, konten, layanan-layanan dan jasa-jasa pembayaran yang disediakan oleh Qoin Service. Dengan menggunakan situs Qoin Service maka pengguna dinyatakan setuju untuk mematuhi “Ketentuan Layanan Qoin Service” (atau disebut dengan “Ketentuan Layanan") serta Kebijakan Privasi Qoin Service.',
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'A. Definisi',
              style: GoogleFonts.lato(
                color: const Color(0xff0A0A0A),
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              """
1. Qoin Service adalah platform penyedia produk API yang dapat digunakan untuk berbagai macam kebutuhan developer. Qoin Service juga menjamin keamanan data akun pengguna karena satu identitas hanya dapat digunakan untuk akun.
2. Akun Qoin service adalah seluruh pengguna yang terdaftar di platform Qoin Service. Akun Qoin Service digunakan oleh pengguna sebagai akses masuk dan untuk memanfaatkan fasilitas atau layanan-layanan Qoin Service.
3. Pengguna atau Pengguna Qoin Service adalah setiap orang yang terdaftar sebagai pemilik akun Qoin Service.
4. Transaksi adalah seluruh transaksi yang dapat dilakukan oleh Pengguna menggunakan platform Qoin service, baik di dalam wilayah Indonesia maupun di luar wilayah Indonesia (sebagaimana relevan), baik yang telah tersedia melalui fitur-fitur pada platform Qoin service, maupun transaksi yang akan dikembangkan di masa yang akan datang.
""",
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'B. Ketentuan Umum',
              style: GoogleFonts.lato(
                color: const Color(0xff0A0A0A),
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              """
1. Pengguna baru dapat menggunakan akun Qoin Service setelah menyetujui Syarat & Ketentuan dan Kebijakan Privasi, kemudian melakukan aktivasi atau pendaftaran dengan menggunakan nomor handphone atau email serta memberikan informasi yang dibutuhkan.
2. Transaksi dapat dilakukan penolakan apabila sewaktu-waktu sistem keamanan Qoin Service menemukan dan menganggap bahwa transaksi yang dilakukan tidak wajar.
""",
              style: GoogleFonts.lato(
                color: const Color(0xff616161),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'C. Aktivasi Qoin Service',
              style: GoogleFonts.lato(
                color: const Color(0xff0A0A0A),
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              """
1. Pengguna wajib memastikan data, informasi dan/atau keterangan yang diberikan, dicantumkan, dan disampaikan pada situs Qoin Service adalah benar dan valid. Pengguna dapat mendaftarkan akun Qoin Service dengan cara berikut:
melakukan proses registrasi dengan mengikuti petunjuk dan memasukkan data antara lain:
\t a. Nama Pengguna,
\t b. Nomor ponsel aktif,
\t c. OTP (One Time Password) yang dikirimkan ke nomor ponsel
\t d. PIN (6 digit angka)
2. Pengguna wajib menjamin informasi dan data yang diberikan adalah benar dan akurat
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
