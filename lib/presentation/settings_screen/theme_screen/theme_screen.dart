import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/presentation/widget/appbar_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: AppColor.shape,
      appBar: AppBarWidget(
        title: 'Theme',
        onBack: () {
          Get.back();
        },
      ),
    );
  }
}