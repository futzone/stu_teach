import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_app/src/models/work_model.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';

final worksProvider = FutureProvider((ref) async {
  AppFirestoreServices appFirestoreServices = AppFirestoreServices();
  final fireData = await appFirestoreServices.readData(collection: appFirestoreServices.workCollection);
  List<WorkModel> tasks = [];
  for (final item in fireData) {
    item as QueryDocumentSnapshot;
    tasks.add(WorkModel.fromJson(item.data()));
  }

  return tasks;
});

final userWorksProvider = FutureProvider.family((Ref ref, String id) async {
  AppFirestoreServices appFirestoreServices = AppFirestoreServices();
  final fireData = await appFirestoreServices.query(collection: appFirestoreServices.workCollection, key: 'userID', equal: id, limit: 99);
  List<WorkModel> tasks = [];
  for (final item in fireData) {
    tasks.add(WorkModel.fromJson(item.data()));
  }

  return tasks;
});
