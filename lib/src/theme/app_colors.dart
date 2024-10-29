import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/services/database_services/theme_mode_db.dart';

Color mainColor = const Color(0xff4CAF50);

final themeModeProvider = FutureProvider((ref) async {
  final mode = await HiveThemeMode.getInitialTheme();
  final isUserMode = await HiveThemeMode.getInitialMode();
  return AppColors(mode, isUserMode);
});

class AppColors {
  bool isDark;
  bool isUserMode;

  AppColors(this.isDark, this.isUserMode);

  Color black = const Color(0xff0a0b11);
  Color white = Colors.white;
  Color yellow = Colors.yellow;
  Color testColor = Colors.pink;
  Color appbarIconColor = Colors.white;
  Color appbarTextColor = Colors.white;

  Color get appbarColor => isDark ? const Color(0xff1E1E1E) : const Color(0xffeff5ef);

  Color get mainColor => isUserMode ? const Color(0xff4CAF50) : Colors.blue;

  Color get scaffoldBgColor => isDark ? const Color(0xff121212) : const Color(0xffFFFFFF);

  Color get secondaryBgColor => isDark ? const Color(0xFF33484B) : const Color(0xFFDBE8E2);

  Color get textColor => isDark ? white : black;

  Color get iconColor => isDark ? white : black;

  Color get secondaryTextColor => isDark ? const Color(0xffBDBDBD) : const Color(0xff757575);

  Color get baseColor => isDark ? Colors.black : Colors.white;

  Color get highlightColor => isDark ? Colors.blueGrey : Colors.grey;

  Color get errorColor => Colors.red;

  Color get secondaryWhite => const Color(0xffDADADA);

  List<Color> get gradientColors => isDark ? [const Color(0xff43A047), const Color(0xff66BB6A)] : [const Color(0xff4CAF50), const Color(0xff8BC34A)];
}

class AppThemeWrapper extends ConsumerWidget {
  final String? language;
  final Widget Function(AppColors colors) builder;

  const AppThemeWrapper({super.key, this.language, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(themeModeProvider).when(
          data: (theme) {
            return builder(theme);
          },
          error: (e, m) {
            return Text(" App base widget: $e, $m");
          },
          loading: () => const SizedBox(width: 0.0),
        );
  }
}
