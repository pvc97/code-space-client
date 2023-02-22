import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void stateStatusListener(
  BuildContext context,
  BaseState state, {
  VoidCallback? onLoading,
  VoidCallback? onError,
}) {
  switch (state.stateStatus) {
    case StateStatus.loading:
      EasyLoading.show(dismissOnTap: true);
      break;
    case StateStatus.error:
      EasyLoading.dismiss();
      if (state.error is NoNetworkException) {
        EasyLoading.showInfo(S.of(context).no_network, dismissOnTap: true);
      } else {
        EasyLoading.showInfo(state.error?.message ?? '', dismissOnTap: true);
      }
      break;
    case StateStatus.success:
      EasyLoading.dismiss();
      break;
    default:
      EasyLoading.dismiss();
      break;
  }
}
