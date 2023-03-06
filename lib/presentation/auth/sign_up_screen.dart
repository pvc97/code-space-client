import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/extensions/string_ext.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _username, _fullName, _email, _password;

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

    context.read<AuthCubit>().registerStudent(
          userName: _username!,
          fullName: _fullName!,
          email: _email!,
          password: _password!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: stateStatusListener,
      child: Scaffold(
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).sign_up),
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
                            return S.of(context).passwords_do_not_match;
                          }
                          return null;
                        },
                      ),
                      Box.h16,
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return FractionallySizedBox(
                            widthFactor: 0.7,
                            child: AppElevatedButton(
                              onPressed:
                                  state.stateStatus == StateStatus.loading
                                      ? null
                                      : _submit,
                              text: S.of(context).sign_up,
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
