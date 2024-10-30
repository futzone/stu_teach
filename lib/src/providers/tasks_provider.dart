import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';

final tasksProvider = FutureProvider((ref) async {
  AppFirestoreServices appFirestoreServices = AppFirestoreServices();
  final fireData = await appFirestoreServices.readData(collection: appFirestoreServices.taskCollection);
  List<TaskModel> tasks = [];
  for (final item in fireData) {
    item as QueryDocumentSnapshot;
    tasks.add(TaskModel.fromJson(item.data()));
  }

  return tasks;
});

final userTasksProvider = FutureProvider.family((ref, String id) async {
  AppFirestoreServices appFirestoreServices = AppFirestoreServices();
  final fireData = await appFirestoreServices.query(collection: appFirestoreServices.taskCollection, key: 'teacherId', equal: id, limit: 99);
  List<TaskModel> tasks = [];
  for (final item in fireData) {
    // item as QueryDocumentSnapshot;
    tasks.add(TaskModel.fromJson(item.data()));
  }

  return tasks;
});

final oneTaskProvider = FutureProvider.family((ref, String id) async {
  AppFirestoreServices appFirestoreServices = AppFirestoreServices();
  final fireData = await appFirestoreServices.query(collection: appFirestoreServices.taskCollection, key: 'id', equal: id);
  if (fireData.isEmpty) return null;
  return TaskModel.fromJson(fireData.first.data());
});
