import 'package:code_space_client/blocs/course/course_bloc.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/course_list/course_list_view.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseListScreen extends StatefulWidget {
  final bool me;

  const CourseListScreen({
    Key? key,
    this.me = false,
  }) : super(key: key);

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();
    logger.d('onlyMyCourses: ${widget.me}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseBloc>(
      create: (context) => sl()..add(const GetCourseListEvent()),
      child: CourseListView(
        me: widget.me,
      ),
    );
  }
}
