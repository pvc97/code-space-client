import 'package:code_space_client/blocs/reset_password/reset_password_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/presentation/reset_password/reset_password_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String userId;

  const ResetPasswordScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (context) => sl(),
      child: ResetPasswordView(
        userId: userId,
      ),
    );
  }
}
