import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/theme/app_colors.dart';

class UsersPage extends HookConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppThemeWrapper(builder: (theme) {
      return Scaffold();
    });
  }
}
