import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/update_course/update_course_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/update_course/update_course_view.dart';

class UpdateCourseScreen extends StatelessWidget {
  final String courseId;

  const UpdateCourseScreen({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateCourseCubit>(
      create: (context) => sl(),
      child: UpdateCourseView(courseId: courseId),
    );
  }
}
