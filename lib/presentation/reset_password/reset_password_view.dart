import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/reset_password/reset_password_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ResetPasswordView extends StatefulWidget {
  final String userId;

  const ResetPasswordView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _newPassword;

  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context
        .read<ResetPasswordCubit>()
        .resetPassword(userId: widget.userId, newPassword: _newPassword!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (ctx, state) {
        stateStatusListener(
          ctx,
          state,
          onSuccess: () {
            EasyLoading.showInfo(
              S.of(context).reset_password_successfully,
              dismissOnTap: true,
            );
          },
        );
      },
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).reset_password),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Sizes.s20),
              child: Center(
                child: SizedBox(
                  width: Sizes.s300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).new_password,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).new_password_cannot_be_empty;
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _newPassword = value;
                        },
                      ),
                      Box.h12,
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).confirm_new_password,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (_newPasswordController.text != value) {
                            return S.of(context).new_password_do_not_match;
                          }
                          return null;
                        },
                      ),
                      Box.h16,
                      BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                        builder: (context, state) {
                          return FractionallySizedBox(
                            widthFactor: 0.7,
                            child: AppElevatedButton(
                              onPressed:
                                  state.stateStatus == StateStatus.loading
                                      ? null
                                      : _submit,
                              text: S.of(context).reset_password,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
