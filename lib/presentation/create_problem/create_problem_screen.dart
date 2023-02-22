import 'package:flutter/material.dart';

import 'package:code_space_client/presentation/create_problem/create_problem_view.dart';

class CreateProblemScreen extends StatelessWidget {
  final bool me;
  final String courseId;

  const CreateProblemScreen({
    Key? key,
    required this.me,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CreateProblemView();
  }
}
