import 'package:flutter/material.dart';
import 'package:student_app/src/theme/app_theme.dart';

class ShowToast {
  static success({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.colors.secondaryBgColor,
        content: ListTile(
          leading: const Icon(Icons.done, color: Colors.green),
          title: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static warning({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.colors.secondaryBgColor,
        content: ListTile(
          leading: const Icon(Icons.warning, color: Colors.amber),
          title: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static error({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.colors.secondaryBgColor,
        content: ListTile(
          leading: const Icon(Icons.error_outline, color: Colors.redAccent),
          title: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
