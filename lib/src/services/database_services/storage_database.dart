import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class AppStorageDatabase {
  final String audiosFolder = '';
  final String imagesFolder = '';
  final String videosFolder = '';
  final String documentsFolder = '';

  final storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required String filePath,
    required String folder,
    required void Function(double progress) onUpdateProgress,
  }) async {
    final storageRef = storage.ref();
    final fileRef = storageRef.child("$folder/${filePath.split('/').last}");
    final file = File(filePath);
    final uploadTask = fileRef.putFile(file);
    uploadTask.asStream().listen((event) {
      double progress = event.bytesTransferred / event.totalBytes;
      onUpdateProgress(progress * 100);
    });

    return await fileRef.getDownloadURL();
  }
}
