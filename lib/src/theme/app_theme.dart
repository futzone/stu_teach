import 'package:flutter/material.dart';
import 'package:student_app/src/theme/app_colors.dart';

ThemeData appThemeData(AppColors appTheme) {
  return ThemeData(
    datePickerTheme: DatePickerThemeData(
      headerHelpStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: appTheme.textColor,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: appTheme.secondaryBgColor,
    ),
    scaffoldBackgroundColor: appTheme.scaffoldBgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: appTheme.appbarColor,
      iconTheme: IconThemeData(color: appTheme.textColor),
      titleTextStyle: TextStyle(
        color: appTheme.textColor,
        fontSize: 24,
      ),
    ),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}