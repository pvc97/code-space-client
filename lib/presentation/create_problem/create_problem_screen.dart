import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/blocs/create_problem/create_problem_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/create_problem/create_problem_view.dart';

class CreateProblemScreen extends StatelessWidget {
  final bool me;
  final String courseId;
  final CourseDetailBloc? courseDetailBloc;

  const CreateProblemScreen({
    Key? key,
    required this.me,
    required this.courseId,
    this.courseDetailBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateProblemCubit>(
      create: (context) => sl(),
      child: CreateProblemView(
        me: me,
        courseId: courseId,
        courseDetailBloc: courseDetailBloc,
      ),
    );
  }
}
