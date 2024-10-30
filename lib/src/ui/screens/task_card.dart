import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/services/file_services/file_services.dart';
import 'package:student_app/src/theme/app_colors.dart';

import '../pages/other_pages/open_tsk_page.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final AppColors theme;
  final EdgeInsets? margin;

  const TaskCard({
    super.key,
    this.margin,
    required this.theme,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? Dis.only(lr: 16, tb: 8),
      padding: Dis.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.appbarColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.textColor,
            ),
          ),
          if (task.file.isNotEmpty) HBox(8),
          SimpleButton(
            onPressed: () async {
              showAppLoadingDialog(context);
              await FileServices.downloadFile(task.file, task.fileType).then((value) async {
                AppRouter.close(context);
                if (value != null) await FileServices.openFile(value);
              });
            },
            child: Container(
              padding: Dis.only(lr: 8, tb: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.secondaryBgColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_present_outlined, color: theme.textColor, size: 20),
                  WBox(8),
                  Text("${((task.fileSize ?? 0.0) / (1024 * 1024)).toStringAsFixed(2)} Mb   Faylni ko'rish",
                      style: TextStyle(color: theme.textColor)),
                ],
              ),
            ),
          ),
          if (task.description.isNotEmpty) HBox(8),
          if (task.description.isNotEmpty)
            Text(
              task.description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: theme.textColor,
              ),
            ),
          HBox(8),
          Text(
            "Muddat: ${DateFormat('HH:mm yyyy/MM/dd').format(task.deadlineDate)} gacha",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textColor,
            ),
          ),
          HBox(8),
          Text(
            "Qo'shilgan sana: ${DateFormat('HH:mm yyyy/MM/dd').format(task.createdDate)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textColor,
            ),
          ),
          HBox(12),
          AppButton(
            title: "Batafsil",
            onPressed: () => AppRouter.go(context, OpenTskPage(task)),
          ),
        ],
      ),
    );
  }
}
