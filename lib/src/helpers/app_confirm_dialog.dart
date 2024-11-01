import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_app/src/helpers/app_simple_button.dart';
import 'package:student_app/src/theme/app_colors.dart';

void showConfirmDialog({
  required BuildContext context,
  required String title,
  required void Function() onConfirm,
  void Function()? onCancel,
}) {
  if (kIsWeb) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return _CupertinoVersion(
          onConfirm: () {
            Navigator.pop(context);
            onConfirm();
          },
          onCancel: () {
            if (onCancel == null) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              onCancel();
            }
          },
          title: title,
        );
      },
    );
  } else {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return _CupertinoVersion(
            onConfirm: () {
              Navigator.pop(context);
              onConfirm();
            },
            onCancel: () {
              if (onCancel == null) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                onCancel();
              }
            },
            title: title,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return _MaterialVersion(
            onConfirm: () {
              Navigator.pop(context);
              onConfirm();
            },
            onCancel: () {
              if (onCancel == null) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                onCancel();
              }
            },
            title: title,
          );
        },
      );
    }
  }
}

class _CupertinoVersion extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onCancel;
  final String title;

  const _CupertinoVersion({
    required this.onConfirm,
    required this.onCancel,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AppThemeWrapper(builder: (theme) {
        return CupertinoAlertDialog(
          content: Text(
            title,
            style: TextStyle(fontSize: 16, color: theme.textColor),
          ),
          title: const Icon(Icons.warning_amber, color: Colors.amber, size: 40),
          actions: [
            SimpleButton(
              onPressed: onCancel,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "No",
                    style: TextStyle(fontSize: 16, color: theme.errorColor),
                  ),
                ),
              ),
            ),
            SimpleButton(
              onPressed: onConfirm,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "Yes",
                    style: TextStyle(fontSize: 16, color: theme.mainColor),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _MaterialVersion extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onCancel;
  final String title;

  const _MaterialVersion({
    required this.onConfirm,
    required this.onCancel,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AppThemeWrapper(builder: (colors) {
        return AlertDialog(
          backgroundColor: colors.secondaryBgColor,
          title: Text(
            title,
            style: TextStyle(fontSize: 16, color: colors.textColor),
          ),
          icon: const Icon(
            Icons.warning_amber,
            color: Colors.amber,
            size: 40,
          ),
          content: SizedBox(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SimpleButton(
                    onPressed: onCancel,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: colors.errorColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SimpleButton(
                    onPressed: onConfirm,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "Yes",
                          style: TextStyle(fontSize: 16, color: colors.mainColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
