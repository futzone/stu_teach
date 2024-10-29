import 'package:flutter/material.dart';

import 'app_custom_padding.dart';
import 'app_loading_screen.dart';

showAppLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AppLoadingScreen(padding: Dis.all(100));
      });
}
