import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/widgets/adaptive_app_bar.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      listener: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          EasyLoading.show();
          return;
        } else if (state.stateStatus == StateStatus.error) {
          EasyLoading.showError(state.error?.message ?? '');
          return;
        } else if (state.stateStatus == StateStatus.success) {
          EasyLoading.dismiss();
          return;
        }
      },
      child: Scaffold(
        appBar: AdaptiveAppBar(
          title: const Text('Login'),
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
                        return null;
                      },
                      onSaved: (String? value) {
                        _username = value;
                      },
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 16),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.stateStatus == StateStatus.loading
                              ? null
                              : _submit,
                          child: Text(S.of(context).login),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
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
