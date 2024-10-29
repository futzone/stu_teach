import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/theme/app_colors.dart';

import 'app_button.dart';

class AppErrorScreen extends StatelessWidget {
  dynamic message;
  final void Function() onFixError;

  AppErrorScreen({
    super.key,
    required this.onFixError,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    log(message.toString());
    return AppThemeWrapper(builder: (theme) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.red,
              ),
            ),
            HBox(24),
            Text(
              "Qandaydir xatolik yuz berdi. Iltimos, so'rovni qayta urinib ko'ring",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textColor),
              textAlign: TextAlign.center,
            ),
            HBox(24),
            Center(
              child: AppButton(
                title: "Takrorlash",
                onPressed: () {
                  onFixError();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
