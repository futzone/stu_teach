import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_app/firebase_options.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/theme/app_theme.dart';
import 'package:student_app/src/ui/widgets/authorization_state_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    return AppThemeWrapper(
      builder: (appTheme) {
        return MaterialApp(
          builder: (context, child) => ScrollConfiguration(
            behavior: MyBehavior(),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          ),
          theme: appThemeData(appTheme),
          themeMode: appTheme.isDark ? ThemeMode.dark : ThemeMode.system,
          debugShowCheckedModeBanner: false,
          color: appTheme.mainColor,
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: appTheme.appbarColor,
              systemNavigationBarIconBrightness: appTheme.isDark ? Brightness.light : Brightness.dark,
              statusBarIconBrightness: appTheme.isDark ? Brightness.light : Brightness.dark,
            ),
            child: UserAuthorizationStateWidget(),
          ),
        );
      },
    );
  }
}
