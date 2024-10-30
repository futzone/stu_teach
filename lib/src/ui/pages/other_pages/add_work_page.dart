import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_app/src/config/app_router.dart';
import 'package:student_app/src/controllers/work_controller.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/helpers/app_text_field.dart';
import 'package:student_app/src/models/task_model.dart';
import 'package:student_app/src/models/user_model.dart';
import 'package:student_app/src/models/work_model.dart';
import 'package:student_app/src/theme/app_colors.dart';

import '../../../services/file_services/file_services.dart';

class AddWorkPage extends HookConsumerWidget {
  final TaskModel task;
  final UserModel user;
  final WorkModel? work;

  const AddWorkPage({
    super.key,
    this.work,
    required this.task,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: work?.text);
    final filePath = useState(work == null ? '' : work!.file);
    final haveFileChanges = useState(false);

    return AppThemeWrapper(builder: (theme) {
      void onAddWork() {
        WorkController workController = WorkController(
          context: context,
          ref: ref,
          theme: theme,
          taskModel: task,
          filePath: filePath.value,
          userModel: user,
          title: titleController.text.trim(),
        );

        if (work == null) {
          workController.onCreateWork();
          return;
        }

        workController.onUpdateWork(work!);
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
              if (work != null)
                if (work!.file.isNotEmpty) HBox(16),
              if (work != null)
                if (work!.file.isNotEmpty)
                  SimpleButton(
                    onPressed: () async {
                      showAppLoadingDialog(context);
                      await FileServices.downloadFile(work!.file, work!.fileType).then((value) async {
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
                          Text("${((work!.fileSize ?? 0.0) / (1024 * 1024)).toStringAsFixed(2)} Mb   Faylni ko'rish",
                              style: TextStyle(color: theme.textColor)),
                        ],
                      ),
                    ),
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
