import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/controllers/task_controller.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/helpers/app_text_field.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/services/file_services/file_services.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/utils/use_image.dart';

class AddTaskPage extends HookConsumerWidget {
  final TaskModel? task;

  const AddTaskPage({this.task, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: task?.title);
    final descriptionController = useTextEditingController(text: task?.description);
    final deadline = useState(task == null ? '' : task!.deadlineDate.toString());
    final filePath = useState(task == null ? '' : task!.file.toString());
    final haveFileChanges = useState(false);

    return AppThemeWrapper(builder: (theme) {
      ///
      /// onAddTask method
      void onAddTask() {
        TaskController taskController = TaskController(
          ref: ref,
          context: context,
          theme: theme,
          filePath: filePath.value,
          title: titleController.text.trim(),
          deadline: deadline.value,
          description: descriptionController.text.trim(),
        );
        if (task == null) {
          taskController.onCreateTask();
          return;
        }

        taskController.onUpdateTask(task!);
      }

      return Scaffold(
        appBar: AppBar(title: Text(task == null ? "Yangi vazifa" : "Tahrirlash")),
        body: SingleChildScrollView(
          padding: Dis.only(lr: 16, tb: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Talabalar uchun yangi vazifa yaratish",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
              HBox(16),
              AppTextField(
                title: "Vazifa nomi",
                controller: titleController,
                colors: theme,
              ),
              HBox(16),
              AppTextField(
                title: "To'liq tavsifi",
                controller: descriptionController,
                colors: theme,
                radius: 8,
                minLines: 3,
              ),
              HBox(16),
              AppTextField(
                suffixIcon: Icon(Icons.calendar_month, size: 20, color: theme.secondaryTextColor),
                onlyRead: true,
                title: deadline.value.isNotEmpty ? DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(deadline.value)) : 'Deadline vaqti',
                controller: TextEditingController(),
                colors: theme,
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((date) {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 0, minute: 0),
                    ).then((time) {
                      if (time == null) return;
                      DateTime datetime = DateTime.now();
                      if (date != null) datetime = date;

                      deadline.value = datetime
                          .copyWith(
                            hour: time.hour,
                            minute: time.minute,
                            millisecond: 0,
                            microsecond: 0,
                            second: 0,
                          )
                          .toString();
                    });
                  });
                },
              ),
              HBox(16),
              if (task != null)
                if (!haveFileChanges.value)
                  SimpleButton(
                    onPressed: () async {
                      showAppLoadingDialog(context);
                      await FileServices.downloadFile(task!.file, task!.fileType).then((value) async {
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
                          Text("Faylni ko'rish", style: TextStyle(color: theme.textColor)),
                        ],
                      ),
                    ),
                  ),
              if (task != null) HBox(12),
              SimpleButton(
                onPressed: () {
                  FilePicker.platform.pickFiles().then((file) {
                    if (file != null && file.files.isNotEmpty) {
                      filePath.value = file.files.first.path ?? '';
                      haveFileChanges.value = true;
                    }
                  });
                },
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.secondaryTextColor),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!haveFileChanges.value) Icon(Icons.file_upload_rounded, size: 20, color: theme.textColor),
                        Text(
                          haveFileChanges.value ? filePath.value.split('/').last : 'Yangi fayl yuklash',
                          style: TextStyle(fontWeight: FontWeight.w600, color: theme.textColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              HBox(16),
              AppButton(title: task == null ? "Joylash" : 'Yangilash', onPressed: onAddTask),
              HBox(16),
            ],
          ),
        ),
      );
    });
  }
}
