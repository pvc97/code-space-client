import 'package:code_space_client/blocs/problem/problem_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/problem/problem_view.dart';
import 'package:code_space_client/presentation/problem/widgets/result_dialog/result_dialog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProblemScreen extends StatelessWidget {
  final String problemId;
  final String courseId;
  final bool me;

  const ProblemScreen({
    Key? key,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProblemCubit>(
          create: (context) => sl<ProblemCubit>(),
        ),
        BlocProvider<ResultDialogCubit>(
          create: (context) => sl<ResultDialogCubit>(),
        ),
      ],
      child: ProblemView(
        problemId: problemId,
        courseId: courseId,
        me: me,
      ),
    );
  }
}
