import 'package:code_space_client/blocs/create_account/create_account_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/create_account/create_account_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateAccountCubit>(
      create: (context) => sl(),
      child: const CreateAccountView(),
    );
  }
}
