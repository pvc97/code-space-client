import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).sign_up),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).username,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).full_name,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).email,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).password,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).confirm_password,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
