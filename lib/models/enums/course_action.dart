import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum CourseAction {
  edit,
  delete,
}

extension AccountActionExt on CourseAction {
  String getName(BuildContext context) {
    switch (this) {
      case CourseAction.edit:
        return S.of(context).edit;
      case CourseAction.delete:
        return S.of(context).delete;
    }
  }

  Icon get icon {
    switch (this) {
      case CourseAction.edit:
        return const Icon(
          Bootstrap.pencil,
          color: AppColor.popupEditColor,
        );
      case CourseAction.delete:
        return const Icon(
          Bootstrap.trash,
          color: AppColor.popupDeleteColor,
        );
    }
  }
}
