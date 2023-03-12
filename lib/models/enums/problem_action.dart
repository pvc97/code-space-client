import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum ProblemAction {
  edit,
  delete,
}

extension ProblemActionExt on ProblemAction {
  String getName(BuildContext context) {
    switch (this) {
      case ProblemAction.edit:
        return S.of(context).edit;
      case ProblemAction.delete:
        return S.of(context).delete;
    }
  }

  Icon get icon {
    switch (this) {
      case ProblemAction.edit:
        return const Icon(
          Bootstrap.pencil,
          color: AppColor.popupEditColor,
        );
      case ProblemAction.delete:
        return const Icon(
          Bootstrap.trash,
          color: AppColor.popupDeleteColor,
        );
    }
  }
}
