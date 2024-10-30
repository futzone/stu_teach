import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/controllers/work_controller.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/helpers/app_text_field.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/models/user_model.dart';
import 'package:student_app/src/theme/app_colors.dart';

class AddWorkPage extends HookConsumerWidget {
  final TaskModel task;
  final UserModel user;

  const AddWorkPage({
    super.key,
    required this.task,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final filePath = useState('');
    final haveFileChanges = useState(false);

    return AppThemeWrapper(builder: (theme) {
      void onAddWork() {
        WorkController workController = WorkController(
          context: context,
          ref: ref,
          theme: theme,
          taskModel: task,
          userModel: user,
          title: titleController.text.trim(),
        );

        workController.onCreateWork();
      }

      return Scaffold(
        appBar: AppBar(title: Text("Topshirish")),
        body: SingleChildScrollView(
          padding: Dis.only(lr: 16, tb: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vazifani topshirish",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
              HBox(12),
              AppTextField(
                title: "Tavsif",
                controller: titleController,
                colors: theme,
                radius: 8,
                minLines: 3,
              ),
              HBox(16),
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
              AppButton(title: "Topshirish", onPressed: onAddWork),
              HBox(16),
            ],
          ),
        ),
      );
    });
  }
}
