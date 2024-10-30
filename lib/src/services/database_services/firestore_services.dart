import 'package:cloud_firestore/cloud_firestore.dart';

class AppFirestoreServices {
  final _database = FirebaseFirestore.instance;
  final userCollection = "users";
  final taskCollection = "tasks";
  final workCollection = "works";

  Future<String> writeData(String collection, Map<String, dynamic> data) async {
    final reference = await _database.collection(collection).add(data);
    return reference.id;
  }

  Future<void> updateData(String collection, String id, Map<String, dynamic> data) async {
    await _database.collection(collection).doc(id).update(data);
  }

  Future<void> deleteData(String collection, String id) async {
    await _database.collection(collection).doc(id).delete();
  }

  Future<dynamic> readData({required String collection, String? id}) async {
    if (id != null) {
      final data = await _database.collection(collection).doc(id).get();
      return data.data();
    }

    final data = await _database.collection(collection).get();
    return data.docs;
  }

  Future<List<DocumentSnapshot>> query({required String collection, required String key, required dynamic equal, int limit = 1}) async {
    try {
      QuerySnapshot snapshot = await _database.collection(collection).where(key, isEqualTo: equal).limit(limit).get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
