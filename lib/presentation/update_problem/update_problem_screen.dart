import 'package:code_space_client/blocs/update_problem/update_problem_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/update_problem/update_problem_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProblemScreen extends StatelessWidget {
  final String problemId;

  const UpdateProblemScreen({
    Key? key,
    required this.problemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProblemCubit>(
      create: (context) => sl(),
      child: UpdateProblemView(problemId: problemId),
    );
  }
}
