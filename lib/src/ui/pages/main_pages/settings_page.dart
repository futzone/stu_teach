import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_app/src/controllers/authorization_controller.dart';
import 'package:student_app/src/services/database_services/theme_mode_db.dart';
import 'package:student_app/src/theme/app_colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return AppThemeWrapper(builder: (theme) {
      ///
      /// onExit method
      void onExit() {
        AuthorizationController controller = AuthorizationController(
          context: context,
          theme: theme,
          isUser: theme.isUserMode,
        );

        controller.onLogout();
      }

      ///
      /// onChangeThemeMode method
      void onChangeThemeMode() {
        HiveThemeMode.setTheme(!theme.isDark).then(
          (_) => ref.invalidate(themeModeProvider),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text("Sozlamalar"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: onChangeThemeMode,
              leading: theme.isDark
                  ? Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.amber,
                    )
                  : Icon(
                      Icons.nights_stay_outlined,
                      color: Colors.blue,
                    ),
              title: Text(
                "Ilova mavzusini o'rgartirish",
                style: TextStyle(
                  color: theme.textColor,
                ),
              ),
            ),
            ListTile(
              onTap: onExit,
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                "Chiqish",
                style: TextStyle(
                  color: theme.textColor,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
