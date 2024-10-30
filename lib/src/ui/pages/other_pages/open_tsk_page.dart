import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/controllers/task_controller.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_error_screen.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_loading_screen.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/providers/task_state_provider.dart';
import 'package:student_app/src/providers/user_provider.dart';
import 'package:student_app/src/services/file_services/file_services.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/other_pages/add_task_page.dart';

import 'add_work_page.dart';

class OpenTskPage extends ConsumerWidget {
  final TaskModel task;

  const OpenTskPage(this.task, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    return AppThemeWrapper(builder: (theme) {
      return ref.watch(userProvider).when(
            loading: () => AppLoadingScreen(),
            error: (e, m) => AppErrorScreen(
              onFixError: () => ref.invalidate(userProvider),
              message: "$e $m",
            ),
            data: (data) {
              return ref.watch(taskStateProvider(task.id)).when(
                    loading: () => AppLoadingScreen(),
                    error: (e, m) => AppErrorScreen(
                        onFixError: () {
                          ref.invalidate(taskStateProvider(task.id));
                        },
                        message: "$e, $m"),
                    data: (taskState) {
                      return Scaffold(
                        appBar: AppBar(
                          actions: [
                            if (data.userID == task.teacherId)
                              IconButton(
                                onPressed: () => AppRouter.go(context, AddTaskPage(task: task)),
                                icon: Icon(Icons.edit),
                              ),
                            if (data.userID == task.teacherId)
                              IconButton(
                                onPressed: () {
                                  TaskController controller = TaskController(ref: ref, context: context, theme: theme);
                                  controller.onDeleteTask(task.id);
                                },
                                icon: Icon(Icons.delete_outline),
                              ),
                          ],
                        ),
                        body: SingleChildScrollView(
                          padding: Dis.only(lr: 16, tb: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textColor,
                                ),
                              ),
                              if (task.file.isNotEmpty) HBox(8),
                              SimpleButton(
                                onPressed: () async {
                                  showAppLoadingDialog(context);
                                  await FileServices.downloadFile(task.file, task.fileType).then((value) async {
                                    AppRouter.close(context);
                                    if (value != null) await FileServices.openFile(value);
                                  });
                                },
                                child: Container(
                                  padding: Dis.only(lr: 8, tb: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: theme.secondaryBgColor,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.file_present_outlined, color: theme.textColor, size: 20),
                                      WBox(8),
                                      Text("Faylni ko'rish", style: TextStyle(color: theme.textColor)),
                                    ],
                                  ),
                                ),
                              ),
                              if (task.description.isNotEmpty) HBox(8),
                              if (task.description.isNotEmpty)
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textColor,
                                  ),
                                ),
                              HBox(8),
                              Text(
                                "Muddat: ${DateFormat('HH:mm yyyy/MM/dd').format(task.deadlineDate)} gacha",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textColor,
                                ),
                              ),
                              HBox(8),
                              Text(
                                "Qo'shilgan sana: ${DateFormat('HH:mm yyyy/MM/dd').format(task.createdDate)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textColor,
                                ),
                              ),
                              HBox(8),
                              if (theme.isUserMode)
                                Text(
                                  "O'qituvchi: ${task.teacherName}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        bottomNavigationBar: data.role == 'teacher'
                            ? null
                            : taskState != null
                                ? null
                                : Container(
                                    height: 56,
                                    padding: Dis.only(lr: 16, top: 4, bottom: 2),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: theme.appbarColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Center(
                                      child: AppButton(
                                        title: "Topshirish",
                                        onPressed: () {
                                          AppRouter.go(context, AddWorkPage(task: task, user: data));
                                        },
                                      ),
                                    ),
                                  ),
                      );
                    },
                  );
            },
          );
    });
  }
}
