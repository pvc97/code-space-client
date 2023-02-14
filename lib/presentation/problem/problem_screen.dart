import 'package:code_space_client/cubits/problem/problem_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/problem/problem_view.dart';
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
    return BlocProvider<ProblemCubit>(
      create: (context) => sl<ProblemCubit>(),
      child: ProblemView(
        problemId: problemId,
        courseId: courseId,
        me: me,
      ),
    );
  }
}
