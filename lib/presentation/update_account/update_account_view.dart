import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/update_account/update_account_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/extensions/string_ext.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UpdateAccountView extends StatefulWidget {
  final String userId;

  const UpdateAccountView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UpdateAccountView> createState() => _UpdateAccountViewState();
}

class _UpdateAccountViewState extends State<UpdateAccountView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _fullName, _email;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Have to fetch user info after the widget is built
    // To prevent missing state loading
    // If call fetchUserInfo() in initState without delay
    // loading state occurs before the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpdateAccountCubit>().fetchUserInfo(widget.userId);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context.read<UpdateAccountCubit>().updateAccount(
          userId: widget.userId,
          name: _fullName!,
          email: _email!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateAccountCubit, UpdateAccountState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        BlocListener<UpdateAccountCubit, UpdateAccountState>(
          listenWhen: (previous, current) =>
              previous.user != current.user && current.user != null,
          listener: (context, state) {
            final newName = state.user!.name;
            final newEmail = state.user!.email;

            if (newName != _fullNameController.text) {
              _fullNameController.text = newName;
            }

            if (newEmail != _emailController.text) {
              _emailController.text = newEmail;
            }
          },
        ),
        BlocListener<UpdateAccountCubit, UpdateAccountState>(
          listenWhen: (previous, current) =>
              previous.updateStatus != current.updateStatus,
          listener: (context, state) {
            stateStatusListener(
              context,
              state,
              stateStatus: state.updateStatus,
              onSuccess: () {
                EasyLoading.showSuccess(
                  S.of(context).update_account_successfully,
                  dismissOnTap: true,
                );
              },
            );
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).update_account),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(Sizes.s20),
              child: Box(
                width: Sizes.s600,
                child: Column(
                  children: [
                    Box.h24,
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).full_name,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).full_name_cannot_be_empty;
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _fullName = value;
                      },
                    ),
                    Box.h12,
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).email,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).email_cannot_be_empty;
                        }

                        if (!value.isValidEmail()) {
                          return S.of(context).username_only_alphanumeric;
                        }

                        return null;
                      },
                      onSaved: (String? value) {
                        _email = value;
                      },
                    ),
                    Box.h16,
                    BlocBuilder<UpdateAccountCubit, UpdateAccountState>(
                      buildWhen: (previous, current) {
                        return previous.stateStatus != current.stateStatus ||
                            previous.updateStatus != current.updateStatus;
                      },
                      builder: (context, state) {
                        return FractionallySizedBox(
                          widthFactor: 0.7,
                          child: AppElevatedButton(
                            onPressed: (state.stateStatus ==
                                        StateStatus.loading ||
                                    state.updateStatus == StateStatus.loading)
                                ? null
                                : _submit,
                            text: S.of(context).update,
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
    );
  }
}
