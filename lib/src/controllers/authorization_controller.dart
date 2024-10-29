import 'package:flutter/cupertino.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_toast.dart';
import 'package:student_app/src/services/authorization_services/authorization.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/main_pages/main_page.dart';

class AuthorizationController {
  final BuildContext context;
  final AppColors theme;
  String? password;
  String? email;
  String? fullname;

  AuthorizationController({
    required this.context,
    required this.theme,
    this.email,
    this.password,
    this.fullname,
  });

  void onSignIn() async {
    if (password == null || password!.length < 6) {
      ShowToast.error(
        context: context,
        message: "Parol uzunligi 6 ta belgidan iborat bo'lishi kerak!",
        colors: theme,
      );
      return;
    }

    if (email == null || !email!.contains('@')) {
      ShowToast.error(
        context: context,
        message: "Iltimos, email-ni to'g'ri kiriting!",
        colors: theme,
      );
      return;
    }

    showAppLoadingDialog(context);
    AuthServices authServices = AuthServices();
    await authServices.signIn(email!, password!).then((value) {
      AppRouter.close(context);
      if (value) {
        AppRouter.open(context, MainPage());
      } else {
        ShowToast.error(
          context: context,
          message: "Email yoki parol xato kiritildi. Iltimos, tekshirib, qayta urinib ko'ring",
          colors: theme,
        );
      }
    });
  }

  void onSignUp() async {
    if (fullname == null || fullname!.isEmpty) {
      ShowToast.error(
        context: context,
        message: "Ism familiyangizni kiritmadingiz!",
        colors: theme,
      );
      return;
    }

    if (password == null || password!.length < 6) {
      ShowToast.error(
        context: context,
        message: "Parol uzunligi 6 ta belgidan iborat bo'lishi kerak!",
        colors: theme,
      );
      return;
    }

    if (email == null || !email!.contains('@')) {
      ShowToast.error(
        context: context,
        message: "Iltimos, email-ni to'g'ri kiriting!",
        colors: theme,
      );
      return;
    }

    showAppLoadingDialog(context);
    AuthServices authServices = AuthServices();
    await authServices.signUp(email!, password!).then((value) {
      AppRouter.close(context);
      if (value) {
        AppRouter.open(context, MainPage());
      } else {
        ShowToast.error(
          context: context,
          message: "Email allaqachon mavjud!",
          colors: theme,
        );
      }
    });
  }
}
