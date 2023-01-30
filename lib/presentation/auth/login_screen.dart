import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/intl/intl_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () {
              final IntlCubit intlCubit = context.read<IntlCubit>();
              String code = intlCubit.state.locale.languageCode;

              if (code == Languages.english.code) {
                intlCubit.changeLanguage(Languages.vietnamese);
              } else {
                intlCubit.changeLanguage(Languages.english);
              }

              // setState(() {});
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).hello),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().login(
                      username: _usernameController.text.trim(),
                      password: _passwordController.text.trim());
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
