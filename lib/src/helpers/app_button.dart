import 'package:flutter/material.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'app_sized_boxes.dart';

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final BoxBorder? border;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    this.icon,
    this.padding,
    this.color,
    this.border,
    this.textColor,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeWrapper(builder: (theme) {
      return SimpleButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            color: color ?? theme.mainColor,
            border: border,
          ),
          padding: padding ?? Dis.only(tb: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              if (icon != null) WBox(8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
