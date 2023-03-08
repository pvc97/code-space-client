import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum AccountAction {
  edit,
  resetPassword,
  delete,
}

extension AccountActionExt on AccountAction {
  String getName(BuildContext context) {
    switch (this) {
      case AccountAction.edit:
        return S.of(context).edit;
      case AccountAction.resetPassword:
        return S.of(context).reset_password;
      case AccountAction.delete:
        return S.of(context).delete;
    }
  }

  Icon get icon {
    switch (this) {
      case AccountAction.edit:
        return const Icon(
          Bootstrap.pencil,
          color: AppColor.popupEditColor,
        );
      case AccountAction.resetPassword:
        return const Icon(
          Bootstrap.pass,
          color: AppColor.popupChangePasswordColor,
        );
      case AccountAction.delete:
        return const Icon(
          Bootstrap.trash,
          color: AppColor.popupDeleteColor,
        );
    }
  }
}
