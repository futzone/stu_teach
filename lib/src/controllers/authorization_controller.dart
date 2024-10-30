import 'package:flutter/cupertino.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_toast.dart';
import 'package:student_app/src/models/user_model.dart';
import 'package:student_app/src/services/authorization_services/authorization.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/authorization_pages/sign_in_page.dart';
import 'package:student_app/src/ui/pages/main_pages/main_page.dart';

class AuthorizationController {
  final BuildContext context;
  final AppColors theme;
  String? password;
  String? email;
  String? fullname;
  bool isUser;

  AuthorizationController({
    required this.context,
    required this.theme,
    required this.isUser,
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
    await authServices.signIn(email!, password!).then((value) async {
      AppFirestoreServices firestoreServices = AppFirestoreServices();
      final user = await firestoreServices.query(
        collection: firestoreServices.userCollection,
        key: 'email',
        equal: email,
      );

      String? role;
      final data = user.first.data();

      if (data is Map) role = data['role'];

      if (role != (isUser ? 'student' : 'teacher')) {
        ShowToast.error(
          context: context,
          message: "Bunday ${(isUser ? 'talaba' : 'o`qituvchi')} topilmadi. Iltimos, tekshirib, qayta urinib ko'ring",
          colors: theme,
        );
        return;
      }

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
      if (value) {
        UserModel userModel = UserModel(
          userID: '',
          email: email!,
          fullname: fullname!,
          role: isUser ? 'student' : 'teacher',
          registerDate: DateTime.now().toString(),
        );

        AppFirestoreServices firestoreServices = AppFirestoreServices();
        firestoreServices.writeData(firestoreServices.userCollection, userModel.toMap()).then((id) async {
          userModel.userID = id;
          await firestoreServices.updateData(firestoreServices.userCollection, id, userModel.toMap());
        });
      }

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

  void onLogout() async {
    AuthServices authServices = AuthServices();
    await authServices.logout();
    AppRouter.open(context, SignInPage());
  }
}
