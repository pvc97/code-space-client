import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/models/custom_error.dart';
import 'package:code_space_client/services/user_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Get User'),
          onPressed: () async {
            try {
              await Future.wait([
                sl<UserService>().getUserInfo(),
                sl<UserService>().getUserInfo(),
              ]);
            } on CustomError catch (e) {
              debugPrint(e.message);
            }
          },
        ),
      ),
    );
  }
}
