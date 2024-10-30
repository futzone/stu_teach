import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/models/work_model.dart';
import 'package:student_app/src/providers/user_provider.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';

final taskStateProvider = FutureProvider.family((ref, String taskId) async {
  final user = ref.watch(userProvider).value!;

  AppFirestoreServices firestoreServices = AppFirestoreServices();
  final taskStateList = await firestoreServices.query(
    collection: firestoreServices.workCollection,
    key: 'userID',
    equal: user.userID,
  );

  if (taskStateList.isEmpty) return null;

  WorkModel? model;
  for (final item in taskStateList) {
    dynamic map = item.data();
    print(map);
    print(taskId);
    if (map['taskID'] == taskId) {
      model = WorkModel.fromJson(map);
      break;
    }
  }

  return model;
});
