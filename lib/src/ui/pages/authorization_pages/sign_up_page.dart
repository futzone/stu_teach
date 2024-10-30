import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/controllers/authorization_controller.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/helpers/app_text_field.dart';
import 'package:student_app/src/services/database_services/theme_mode_db.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/authorization_pages/sign_in_page.dart';

import '../../../providers/user_provider.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final fullnameController = useTextEditingController();

    return AppThemeWrapper(
      builder: (theme) {
        ///
        ///Register method
        void onRegister() {
          AuthorizationController controller = AuthorizationController(
            context: context,
            theme: theme,
            isUser: theme.isUserMode,
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            fullname: fullnameController.text.trim(),
          );

          controller.onSignUp();
          Future.delayed(Duration(milliseconds: 100), () {
            ref.invalidate(userProvider);
          });
        }

        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: Dis.only(lr: 16, tb: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Ro'yxatdan o'tish",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: theme.textColor),
                  ),
                  HBox(16),
                  AppTextField(
                    title: "Ism familiyani kiriting",
                    controller: fullnameController,
                    colors: theme,
                  ),
                  HBox(16),
                  AppTextField(
                    title: "Emailni kiriting",
                    controller: emailController,
                    colors: theme,
                  ),
                  HBox(16),
                  AppTextField(
                    title: "Passwordni kiriting",
                    controller: passwordController,
                    colors: theme,
                  ),
                  HBox(16),
                  AppButton(title: 'Davom etish', onPressed: onRegister),
                  HBox(16),
                  AppButton(
                    title: theme.isUserMode ? "Men o'qituvchiman" : "Men talabaman",
                    onPressed: () {
                      HiveThemeMode.changeMode(!theme.isUserMode).then((_) => ref.invalidate(themeModeProvider));
                    },
                    color: theme.secondaryBgColor,
                    textColor: theme.textColor,
                  ),
                  HBox(16),
                  RichText(
                    text: TextSpan(
                      text: "Akkauntingiz bormi?",
                      style: TextStyle(
                        color: theme.textColor,
                      ),
                      children: [
                        TextSpan(
                          text: " Kirish",
                          style: TextStyle(
                            color: theme.mainColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => AppRouter.open(
                                  context,
                                  SignInPage(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
