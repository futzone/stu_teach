import 'package:flutter/material.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/theme/app_styles.dart';


class AppTheme {
  static AppColors get colors => AppColors();

  static AppTextStyles get styles => AppTextStyles();
}

void use() {
  AppTheme.styles.style12;
}
