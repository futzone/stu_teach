import 'package:hive_flutter/hive_flutter.dart';

class HiveThemeMode {
  static const String boxName = 'theme';

  static Future<bool> getInitialTheme() async {
    var box = await Hive.openBox(boxName);
    final data = box.get("model");
    return (data ?? true);
  }

  static Future<void> setTheme(bool value) async {
    var box = await Hive.openBox(boxName);
    await box.put("model", value);
  }

  static Future<bool> getInitialMode() async {
    var box = await Hive.openBox(boxName);
    final data = box.get("is_user");
    return (data ?? true);
  }

  static Future<void> changeMode(bool value) async {
    var box = await Hive.openBox(boxName);
    await box.put("is_user", value);
  }
}
