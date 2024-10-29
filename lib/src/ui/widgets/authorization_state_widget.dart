import 'package:flutter/material.dart';
import 'package:student_app/src/helpers/app_error_screen.dart';
import 'package:student_app/src/helpers/app_loading_screen.dart';
import 'package:student_app/src/services/authorization_services/authorization.dart';
import 'package:student_app/src/ui/pages/authorization_pages/sign_in_page.dart';
import '../pages/main_pages/main_page.dart';

class UserAuthorizationStateWidget extends StatelessWidget {
  UserAuthorizationStateWidget({super.key});

  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authServices.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppLoadingScreen();
        } else if (snapshot.hasError) {
          return AppErrorScreen(
            onFixError: () {},
            message: snapshot.error.toString(),
          );
        } else {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return MainPage();
          }
        }
      },
    );
  }
}
