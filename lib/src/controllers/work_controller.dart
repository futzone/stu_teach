import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_toast.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/models/user_model.dart';
import 'package:student_app/src/models/work_model.dart';
import 'package:student_app/src/providers/works_provider.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';
import 'package:student_app/src/services/database_services/storage_database.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/utils/task_status.dart';

class WorkController {
  BuildContext context;
  WidgetRef ref;
  AppColors theme;
  TaskModel taskModel;
  UserModel userModel;
  String title;

  String filePath;

  WorkController({
    required this.context,
    required this.ref,
    required this.theme,
    required this.taskModel,
    required this.userModel,
    this.filePath = '',
    this.title = '',
  });

  void onCreateWork() async {
    if (title.isEmpty) {
      ShowToast.error(context: context, message: 'Tavsif uchun matn kiritilmadi!', colors: theme);
      return;
    }

    showAppLoadingDialog(context);

    double? fileSize;
    String fileUrl = '';
    if (filePath.isNotEmpty) {
      print(filePath);
      final File file = File(filePath);
      final fileStat = await file.stat();
      fileSize = fileStat.size.toDouble();

      AppStorageDatabase storageDatabase = AppStorageDatabase();
      fileUrl = await storageDatabase.uploadFile(filePath: filePath, folder: storageDatabase.documentsFolder, onUpdateProgress: (_) {});
    }

    WorkModel workModel = WorkModel(
      fileSize: fileSize,
      createdDate: DateTime.now().toString(),
      updatedDate: DateTime.now().toString(),
      fileType: filePath.split('.').last.toLowerCase(),
      file: fileUrl,
      userID: userModel.userID,
      text: title,
      status: TaskStatus.pending.name,
      taskID: taskModel.id,
      rate: -1,
      id: '',
    );

    AppFirestoreServices firestoreServices = AppFirestoreServices();
    await firestoreServices.writeData(firestoreServices.workCollection, workModel.toJson()).then((va) async {
      workModel.id = va;
      await firestoreServices.updateData(firestoreServices.workCollection, va, workModel.toJson()).then((_) {
        AppRouter.close(context);
        AppRouter.close(context);
        ref.invalidate(worksProvider);
        AppRouter.close(context);
        ref.invalidate(userWorksProvider(userModel.userID));
      });
    });
  }

  void onUpdateWork(WorkModel work, {bool isRate = false}) async {
    showAppLoadingDialog(context);
    WorkModel newWork = work;
    if (!filePath.contains("http") && filePath.isNotEmpty) {
      final File file = File(filePath);
      final fileStat = await file.stat();
      newWork.fileSize = fileStat.size.toDouble();

      AppStorageDatabase storageDatabase = AppStorageDatabase();
      newWork.file = await storageDatabase.uploadFile(filePath: filePath, folder: storageDatabase.documentsFolder, onUpdateProgress: (_) {});
    }

    newWork.text = title;
    AppFirestoreServices firestoreServices = AppFirestoreServices();
    await firestoreServices.updateData(firestoreServices.workCollection, work.id, newWork.toJson()).then((_) {
      AppRouter.close(context);
      AppRouter.close(context);
      if (!isRate) AppRouter.close(context);
      ref.invalidate(worksProvider);
    });
  }
}
