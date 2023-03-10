import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/create_account/create_account_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/extensions/string_ext.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _username, _fullName, _email, _password, _selectedRole;

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context.read<CreateAccountCubit>().createAccount(
          username: _username!,
          fullName: _fullName!,
          email: _email!,
          password: _password!,
          role: _selectedRole!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateAccountCubit, CreateAccountState>(
            listener: (ctx, state) {
          stateStatusListener(
            ctx,
            state,
            onSuccess: () {
              EasyLoading.showInfo(S.of(context).account_created_successfully,
                  dismissOnTap: true);
            },
          );
        }),
        BlocListener<CreateAccountCubit, CreateAccountState>(
          listenWhen: (previous, current) => previous.userId != current.userId,
          listener: (context, state) {
            final userId = state.userId;
            if (userId != null && context.canPop()) {
              // TODO: Navigate to the user profile page
              context.pop();
            }
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).create_new_account),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Sizes.s20),
              child: Center(
                child: Box(
                  width: Sizes.s300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).username,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).username_cannot_be_empty;
                          }

                          if (!value.isValidUserName()) {
                            return S.of(context).username_only_alphanumeric;
                          }

                          return null;
                        },
                        onSaved: (String? value) {
                          _username = value;
                        },
                      ),
                      Box.h12,
                      TextFormField(
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
                            return S.of(context).email_is_not_valid;
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _email = value;
                        },
                      ),
                      Box.h12,
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).password,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).password_cannot_be_empty;
                          }

                          return null;
                        },
                        onSaved: (String? value) {
                          _password = value;
                        },
                      ),
                      Box.h12,
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).confirm_password,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (_passwordController.text != value) {
                            return S.of(context).password_do_not_match;
                          }
                          return null;
                        },
                      ),
                      Box.h12,
                      DropdownButtonFormField2(
                        buttonOverlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Sizes.s4),
                          ),
                        ),
                        hint: Text(
                          S.of(context).select_role,
                          style: AppTextStyle.defaultFont,
                        ),
                        items: RoleType.values.map((role) {
                          return DropdownMenuItem<String>(
                            value: role.name,
                            child: Text(
                              role.getName(context),
                              style: AppTextStyle.defaultFont,
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return S.of(context).please_select_role;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when changing the item if you want.
                        },
                        onSaved: (value) {
                          _selectedRole = value;
                        },
                        buttonHeight: Sizes.s64,
                      ),
                      Box.h16,
                      BlocBuilder<CreateAccountCubit, CreateAccountState>(
                        builder: (context, state) {
                          return FractionallySizedBox(
                            widthFactor: 0.7,
                            child: AppElevatedButton(
                              onPressed:
                                  state.stateStatus == StateStatus.loading
                                      ? null
                                      : _submit,
                              text: S.of(context).create_account,
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
