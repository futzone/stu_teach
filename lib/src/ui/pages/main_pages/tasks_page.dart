import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/helpers/app_error_screen.dart';
import 'package:student_app/src/helpers/app_loading_screen.dart';
import 'package:student_app/src/providers/tasks_provider.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/other_pages/add_task_page.dart';
import 'package:student_app/src/ui/screens/task_card.dart';

class TasksPage extends HookConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppThemeWrapper(
      builder: (theme) {
        return Scaffold(
          appBar: AppBar(title: Text('Vazifalar')),
          floatingActionButton: theme.isUserMode
              ? null
              : FloatingActionButton(
                  onPressed: () => AppRouter.go(context, AddTaskPage()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
                  backgroundColor: theme.mainColor,
                  child: Icon(Icons.add, color: Colors.white),
                ),
          body: ref.watch(tasksProvider).when(
                loading: () => AppLoadingScreen(),
                error: (e, m) => AppErrorScreen(onFixError: () => ref.invalidate(tasksProvider), message: "$e $m"),
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                      child: Text(
                        'Vazifalar mavjud emas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textColor,
                        ),
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      color: theme.mainColor,
                      backgroundColor: theme.secondaryBgColor,
                      elevation: 0.0,
                      onRefresh: () {
                        ref.invalidate(tasksProvider);

                        return Future.value();
                      },
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return TaskCard(theme: theme, task: data[index]);
                        },
                      ),
                    );
                  }
                },
              ),
        );
      },
    );
  }
}
