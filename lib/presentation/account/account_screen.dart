import 'package:code_space_client/blocs/account/account_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/account/account_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (context) => sl(),
      child: const AccountView(),
    );
  }
}
