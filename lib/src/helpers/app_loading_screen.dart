import 'package:flutter/material.dart';
import 'package:student_app/src/theme/app_colors.dart';

class AppLoadingScreen extends StatelessWidget {
  final EdgeInsets? padding;
  final double size;

  const AppLoadingScreen({this.padding = EdgeInsets.zero, super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return AppThemeWrapper(builder: (theme) {
      return Center(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              color: theme.mainColor,
            ),
          ),
        ),
      );
    });
  }
}
