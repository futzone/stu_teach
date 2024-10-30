import 'dart:io';

import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileServices {
  static Future<String?> downloadFile(String url, String fileType) async {
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/${url.hashCode}.$fileType';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    }

    return null;
  }

  static Future openFile(String path) async {
    await OpenFile.open(path);
  }
}
