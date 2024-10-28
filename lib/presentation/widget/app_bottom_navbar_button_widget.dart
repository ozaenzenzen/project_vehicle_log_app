import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_vehicle_log_app/presentation/widget/app_mainbutton_widget.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';

class AppBottomNavBarButtonWidget extends StatefulWidget {
  final String title;
  final Function() onTap;

  const AppBottomNavBarButtonWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AppBottomNavBarButtonWidget> createState() => _AppBottomNavBarButtonWidgetState();
}

class _AppBottomNavBarButtonWidgetState extends State<AppBottomNavBarButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black12,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: 24.h,
      ),
      child: AppMainButtonWidget(
        text: widget.title,
        onPressed: widget.onTap,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
