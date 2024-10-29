import 'package:flutter/material.dart';
import 'package:student_app/src/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final AppColors colors;
  final String title;
  final bool onlyRead;
  final TextEditingController controller;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final void Function()? onChanged;
  final void Function()? onTap;
  final double radius;
  final Color fillColor;

  const AppTextField({
    super.key,
    this.fillColor = Colors.white10,
    this.radius = 48,
    required this.title,
    required this.controller,
    required this.colors,
    this.minLines,
    this.suffixIcon,
    this.maxLines,
    this.onChanged,
    this.onlyRead = false,
    this.prefixIcon,
    this.onTap,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      readOnly: onlyRead,
      onTap: () {
        if (onTap != null) onTap!();
      },
      onChanged: (str) {
        if (onChanged != null) onChanged!();
      },
      maxLines: maxLines,
      minLines: minLines,
      controller: controller,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: colors.textColor,
      ),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(
          color: colors.secondaryTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        filled: true,
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: colors.mainColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: colors.secondaryTextColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
