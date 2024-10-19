import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_vehicle_log_app/support/app_color.dart';

class AppTextFieldWidget extends StatefulWidget {
  final String textFieldTitle;
  final String textFieldHintText;
  final int? maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final bool ignorePointerActive;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool? filled;
  final Color? fillColor;
  final InputBorder? border;
  final double? radius;

  const AppTextFieldWidget({
    Key? key,
    required this.textFieldTitle,
    required this.textFieldHintText,
    this.controller,
    this.maxLines,
    this.readOnly = false,
    this.ignorePointerActive = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.filled = true,
    this.fillColor = AppColor.shape_3,
    this.border,
    this.radius,
  }) : super(key: key);

  @override
  State<AppTextFieldWidget> createState() => _AppTextFieldWidgetState();
}

class _AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  double? height;

  @override
  void initState() {
    // if (widget.textFieldMaxLines != null) {
    //   height = null;
    // } else {
    //   height = 48.h;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 16.h),
        Text(
          // "Email",
          widget.textFieldTitle,
          style: GoogleFonts.inter(
            color: const Color(0xff331814),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          // height: 48.h,
          height: height,
          child: widget.ignorePointerActive
              ? IgnorePointer(
                  child: TextField(
                    obscureText: widget.obscureText,
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    // maxLines: 5,
                    maxLines: (widget.obscureText) ? 1 : widget.maxLines,
                    // minLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: widget.filled,
                      fillColor: widget.fillColor,
                      suffixIcon: widget.suffixIcon,
                      prefixIcon: widget.prefixIcon,
                      contentPadding: EdgeInsets.all(10.h),
                      // hintText: "jane29@gmail.com",
                      hintText: widget.textFieldHintText,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      border: widget.border ??
                          OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: widget.radius != null ? BorderRadius.circular(widget.radius!) : BorderRadius.circular(10),
                          ),
                    ),
                    onChanged: widget.onChanged,
                    readOnly: widget.readOnly,
                    onTap: widget.onTap,
                  ),
                )
              : TextField(
                  obscureText: widget.obscureText,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  // maxLines: 5,
                  maxLines: (widget.obscureText) ? 1 : widget.maxLines,
                  // minLines: 1,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: widget.filled,
                    fillColor: widget.fillColor,
                    suffixIcon: widget.suffixIcon,
                    prefixIcon: widget.prefixIcon,
                    contentPadding: EdgeInsets.all(10.h),
                    // hintText: "jane29@gmail.com",
                    hintText: widget.textFieldHintText,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: widget.border ??
                        OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                          borderRadius: widget.radius != null ? BorderRadius.circular(widget.radius!) : BorderRadius.circular(10),
                        ),
                  ),
                  onChanged: widget.onChanged,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                ),
        ),
      ],
    );
  }
}
