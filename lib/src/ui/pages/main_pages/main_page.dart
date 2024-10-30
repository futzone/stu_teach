import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/main_pages/settings_page.dart';
import 'package:student_app/src/ui/pages/main_pages/tasks_page.dart';
import 'package:student_app/src/ui/pages/main_pages/users_page.dart';
import 'package:student_app/src/ui/pages/main_pages/works_page.dart';
import 'package:student_app/src/ui/widgets/app_navbar.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(0);
    return AppThemeWrapper(
      builder: (theme) {
        return Scaffold(
          bottomNavigationBar: AppNavbar(theme: theme, currentPage: currentPage),
          body: Builder(builder: (context) {
            return [TasksPage(), WorksPage(), UsersPage(), SettingsPage()][currentPage.value];
          }),
        );
      },
    );
  }
}
