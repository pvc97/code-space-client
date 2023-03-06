import 'package:code_space_client/blocs/cubit/change_password_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/change_password/change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordCubit>(
      create: (context) => sl(),
      child: const ChangePasswordView(),
    );
  }
}
