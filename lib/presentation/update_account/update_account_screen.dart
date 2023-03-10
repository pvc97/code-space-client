import 'package:code_space_client/blocs/update_account/update_account_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/presentation/update_account/update_account_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateAccountScreen extends StatelessWidget {
  final String userId;

  const UpdateAccountScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateAccountCubit>(
      create: (context) => sl(),
      child: UpdateAccountView(userId: userId),
    );
  }
}
