import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/course_detail/course_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailScreen extends StatelessWidget {
  final bool me;
  final String courseId;

  const CourseDetailScreen({
    Key? key,
    required this.me,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseDetailBloc>(
      create: (context) =>
          sl()..add(CourseDetailGetInitProblemsEvent(courseId: courseId)),
      child: CourseDetailView(me: me, courseId: courseId),
    );
  }
}
