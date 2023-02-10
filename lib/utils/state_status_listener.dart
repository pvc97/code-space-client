import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void stateStatusListener(
  BuildContext context,
  BaseState state, {
  VoidCallback? onSuccess,
  VoidCallback? onLoading,
  VoidCallback? onError,
}) {
  switch (state.stateStatus) {
    case StateStatus.loading:
      EasyLoading.show();
      break;
    case StateStatus.error:
      EasyLoading.dismiss();
      if (state.error is NoNetworkException) {
        EasyLoading.showInfo(S.of(context).no_network);
      } else {
        EasyLoading.showInfo(state.error?.message ?? '');
      }
      break;
    case StateStatus.success:
      EasyLoading.dismiss();
      onSuccess?.call();
      break;
    default:
      EasyLoading.dismiss();
      break;
  }
}
