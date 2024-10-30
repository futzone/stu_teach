import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_app/src/models/user_model.dart';
import 'package:student_app/src/services/authorization_services/authorization.dart';
import 'package:student_app/src/services/database_services/firestore_services.dart';

final userProvider = FutureProvider((ref) async {
  AuthServices authServices = AuthServices();
  final user = authServices.currentUser();

  AppFirestoreServices appFirestoreServices = AppFirestoreServices();
  final userMapList = await appFirestoreServices.query(
    collection: appFirestoreServices.userCollection,
    key: 'email',
    equal: user?.email,
  );

  final userMap = userMapList.first.data();
  return UserModel.fromMap(userMap);
});
