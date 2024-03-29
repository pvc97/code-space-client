import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/string_ext.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _username, _password;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context
        .read<AuthCubit>()
        .login(username: _username!.trim(), password: _password!.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: stateStatusListener,
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).login_screen_title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300.0),
                child: ListView(
                  shrinkWrap: true,
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
                    Box.h16,
                    TextFormField(
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
                    Box.h16,
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppElevatedButton(
                          onPressed: state.stateStatus == StateStatus.loading
                              ? null
                              : _submit,
                          text: S.of(context).login,
                        );
                      },
                    ),
                    Box.h16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(S.of(context).dont_have_an_account),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(AppRoute.signUp.name);
                          },
                          child: Text(S.of(context).sign_up),
                        ),
                      ],
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
