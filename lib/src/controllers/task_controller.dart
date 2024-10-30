import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_toast.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/providers/tasks_provider.dart';
import 'package:student_app/src/services/authorization_services/authorization.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';
import 'package:student_app/src/services/database_services/storage_database.dart';
import 'package:student_app/src/theme/app_colors.dart';

class TaskController {
  BuildContext context;
  WidgetRef ref;
  AppColors theme;
  String title;
  String description;
  String deadline;
  String filePath;

  TaskController({
    this.title = '',
    this.description = '',
    this.filePath = '',
    this.deadline = '',
    required this.ref,
    required this.context,
    required this.theme,
  });

  void onCreateTask() async {
    if (title.isEmpty) {
      ShowToast.error(context: context, message: 'Vazifa nomini kiriting!', colors: theme);
      return;
    }

    if (deadline.isEmpty) {
      ShowToast.error(context: context, message: 'Vazifa uchun muddat kiriting!', colors: theme);
      return;
    }
    showAppLoadingDialog(context);
    AuthServices authServices = AuthServices();
    final user = authServices.currentUser();

    if (user == null) {
      Navigator.pop(context);
      return;
    }

    AppFirestoreServices firestoreServices = AppFirestoreServices();
    final userMap = await firestoreServices.query(
      collection: firestoreServices.userCollection,
      key: 'email',
      equal: user.email.toString(),
    );

    if (userMap.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final fireUser = userMap.first.data() as Map;

    String filePathUrl = '';
    double fileSize = 0.0;
    if (filePath.isNotEmpty) {
      final file = File(filePath);
      final stat = await file.stat();
      fileSize = stat.size.toDouble();
      AppStorageDatabase database = AppStorageDatabase();
      filePathUrl = await database.uploadFile(filePath: filePath, folder: database.documentsFolder, onUpdateProgress: (p) {});
    }

    TaskModel taskModel = TaskModel(
      fileSize: fileSize,
      title: title,
      description: description,
      file: filePathUrl,
      fileType: filePath.split('.').last.toLowerCase(),
      updatedDate: DateTime.now(),
      createdDate: DateTime.now(),
      deadlineDate: DateTime.parse(deadline),
      teacherId: fireUser['user_id'],
      teacherName: fireUser['fullname'],
    );

    await firestoreServices.writeData(firestoreServices.taskCollection, taskModel.toJson()).then((val) async {
      taskModel.id = val;
      await firestoreServices.updateData(firestoreServices.taskCollection, val, taskModel.toJson()).then((_) {
        AppRouter.close(context);
        ref.invalidate(tasksProvider);
        AppRouter.close(context);
      });
    });
  }

  void onUpdateTask(TaskModel task) async {
    showAppLoadingDialog(context);

    TaskModel taskModel = task;
    taskModel.title = title;
    taskModel.description = description;
    taskModel.deadlineDate = DateTime.parse(deadline);
    taskModel.updatedDate = DateTime.now();

    print(task.id);

    if (!filePath.contains('https')) {
      String filePathUrl = '';
      double fileSize = 0.0;
      final file = File(filePath);
      if (file.existsSync()) {
        final stat = await file.stat();
        fileSize = stat.size.toDouble();
        AppStorageDatabase database = AppStorageDatabase();
        filePathUrl = await database.uploadFile(filePath: filePath, folder: database.documentsFolder, onUpdateProgress: (p) {});

        taskModel.file = filePathUrl;
        taskModel.fileSize = fileSize;
      }
    }

    AppFirestoreServices firestoreServices = AppFirestoreServices();
    await firestoreServices.updateData(firestoreServices.taskCollection, task.id, taskModel.toJson()).then((_) {
      AppRouter.close(context);
      ref.invalidate(tasksProvider);
      AppRouter.close(context);
      AppRouter.close(context);
    });
  }

  void onDeleteTask(String taskId) async {
    showAppLoadingDialog(context);
    AppFirestoreServices firestoreServices = AppFirestoreServices();
    await firestoreServices.deleteData(firestoreServices.taskCollection, taskId).then((_) {
      AppRouter.close(context);
      ref.invalidate(tasksProvider);
      AppRouter.close(context);
    });
  }
}
