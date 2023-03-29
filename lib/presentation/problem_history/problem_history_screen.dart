import 'package:code_space_client/blocs/problem_history/problem_history_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/problem_history/problem_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProblemHistoryScreen extends StatelessWidget {
  final String problemId;
  final String courseId;
  final bool me;

  const ProblemHistoryScreen({
    Key? key,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProblemHistoryCubit>(
      create: (context) => sl(),
      child: ProblemHistoryView(
        problemId: problemId,
        courseId: courseId,
        me: me,
      ),
    );
  }
}
