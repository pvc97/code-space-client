import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';

void showConfirmDialog({
  required BuildContext ctx,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
  Function()? onConfirm,
}) {
  showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          content,
          style: AppTextStyle.defaultFont,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              cancelText ?? S.of(context).cancel,
              style: AppTextStyle.defaultFont,
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context);
            },
            child: Text(
              confirmText ?? S.of(context).ok,
              style: AppTextStyle.defaultFont,
            ),
          ),
        ],
      );
    },
  );
}
