import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_app/src/controllers/work_controller.dart';
import 'package:student_app/src/helpers/app_button.dart';
import 'package:student_app/src/helpers/app_custom_padding.dart';
import 'package:student_app/src/helpers/app_error_screen.dart';
import 'package:student_app/src/helpers/app_loading_dialog.dart';
import 'package:student_app/src/helpers/app_loading_screen.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/helpers/app_sized_boxes.dart';
import 'package:student_app/src/helpers/app_text_field.dart';
import 'package:student_app/src/helpers/app_toast.dart';
import 'package:student_app/src/models/user_model.dart';
import 'package:student_app/src/models/work_model.dart';
import 'package:student_app/src/services/file_services/file_services.dart';
import 'package:student_app/src/theme/app_colors.dart';
import 'package:student_app/src/ui/pages/other_pages/add_work_page.dart';
import 'package:student_app/src/ui/screens/task_card.dart';
import 'package:student_app/src/utils/task_status.dart';

import '../../../config/app_router.dart';
import '../../../providers/tasks_provider.dart';

class OpenWrkPage extends HookConsumerWidget {
  final WorkModel workModel;
  final UserModel userModel;

  const OpenWrkPage({
    super.key,
    required this.userModel,
    required this.workModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    return AppThemeWrapper(builder: (theme) {
      return ref.watch(oneTaskProvider(workModel.taskID)).when(
            error: (e, m) => AppErrorScreen(onFixError: () => ref.invalidate(oneTaskProvider(workModel.taskID)), message: "$e $m"),
            loading: () => AppLoadingScreen(),
            data: (task) {
              return Scaffold(
                appBar: AppBar(
                  actions: [
                    if (workModel.userID == userModel.userID)
                      IconButton(
                        onPressed: () {
                          AppRouter.go(
                            context,
                            AddWorkPage(task: task!, user: userModel, work: workModel),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: Dis.only(lr: 16, tb: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Topshiriq",
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TaskCard(
                        theme: theme,
                        task: task!,
                        margin: Dis.only(tb: 4),
                      ),
                      HBox(12),
                      Text(
                        theme.isUserMode ? "Siz topshirgan yechim" : "Talaba tomonidan topshirilgan yechim",
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      HBox(8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.appbarColor,
                        ),
                        padding: Dis.all(12),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (workModel.file.isNotEmpty) HBox(8),
                            if (workModel.file.isNotEmpty)
                              SimpleButton(
                                onPressed: () async {
                                  showAppLoadingDialog(context);
                                  await FileServices.downloadFile(workModel.file, workModel.fileType).then((value) async {
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
                                      Text("${((workModel.fileSize ?? 0.0) / (1024 * 1024)).toStringAsFixed(2)} Mb   Faylni ko'rish",
                                          style: TextStyle(color: theme.textColor)),
                                    ],
                                  ),
                                ),
                              ),
                            if (workModel.file.isNotEmpty) HBox(8),
                            Text(
                              workModel.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            HBox(4),
                            Text(
                              "Topshirilgan sana: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(workModel.createdDate))}",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            HBox(4),
                            Text(
                              "Topshirilgan ish statusi: ${workModel.status == 'pending' ? 'Baholash kutilmoqda' : 'Baholangan'}",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (workModel.rate > 0) HBox(4),
                            if (workModel.rate > 0)
                              Text(
                                "Baholash natijasi: ${workModel.rate.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (workModel.rate > 0) HBox(4),
                            if (workModel.rate > 0)
                              Text(
                                "Baholangan sana: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(workModel.updatedDate))}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      HBox(16),
                      if (userModel.userID == task.teacherId)
                        Text(
                          "Talabani baholash",
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      HBox(8),
                      if (userModel.userID == task.teacherId)
                        AppTextField(
                          title: "Ballni kiriting",
                          controller: controller,
                          colors: theme,
                          textInputType: TextInputType.number,
                        ),
                      HBox(16),
                      if (userModel.userID == task.teacherId)
                        AppButton(
                          title: "Baholash",
                          onPressed: () {
                            WorkController wController = WorkController(
                              context: context,
                              ref: ref,
                              theme: theme,
                              taskModel: task,
                              userModel: userModel,
                              title: workModel.text,
                            );
                            final rate = double.tryParse(controller.text.trim());
                            if (rate == null) {
                              ShowToast.error(context: context, message: 'Baho kiritilmadi', colors: theme);
                              return;
                            }
                            WorkModel work = workModel;
                            work.rate = rate;
                            work.updatedDate = DateTime.now().toString();
                            work.status = TaskStatus.rated.name;

                            wController.onUpdateWork(work, isRate: true);
                          },
                        )
                    ],
                  ),
                ),
              );
            },
          );
    });
  }
}
