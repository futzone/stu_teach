import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/theme/app_colors.dart';

class AppNavbar extends HookConsumerWidget {
  final AppColors theme;
  final ValueNotifier<int> currentPage;

  const AppNavbar({super.key, required this.theme, required this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      onTap: (page) => currentPage.value = page,
      currentIndex: currentPage.value,
      selectedItemColor: theme.mainColor,
      backgroundColor: theme.appbarColor,
      unselectedItemColor: theme.secondaryTextColor,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          label: 'Vazifalar',
          backgroundColor: theme.appbarColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist),
          label: 'Ishlar',
          backgroundColor: theme.appbarColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Sozlamalar',
          backgroundColor: theme.appbarColor,
        ),
      ],
    );
  }
}
