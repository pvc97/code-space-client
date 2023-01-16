import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/models/custom_error.dart';
import 'package:code_space_client/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Get User'),
          onPressed: () async {
            try {
              await Future.wait([
                sl<UserService>().getUserInfo(),
                // sl<UserService>().getUserInfo(),
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
