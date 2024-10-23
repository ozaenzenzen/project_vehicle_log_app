import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AppTooltipWidget extends StatelessWidget {
  final SuperTooltipController tooltipController;
  final Widget child;
  final String message;

  const AppTooltipWidget({
    super.key,
    required this.tooltipController,
    required this.child,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      showBarrier: true,
      controller: tooltipController,
      backgroundColor: Colors.black12,
      content: Text(
        message,
        softWrap: true,
        style: GoogleFonts.inter(
          color: AppColor.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: child,
    );
  }
}
