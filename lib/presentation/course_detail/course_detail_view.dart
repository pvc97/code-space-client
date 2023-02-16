import 'package:code_space_client/cubits/course/course_cubit.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CourseDetailView extends StatefulWidget {
  final bool me;
  final String courseId;

  const CourseDetailView({
    Key? key,
    required this.me,
    required this.courseId,
  }) : super(key: key);

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseCubit>().getInitProblems(courseId: widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseCubit, CourseState>(
      listener: stateStatusListener,
      child: Scaffold(
        appBar: AdaptiveAppBar(
          context: context,
          title: Text('Flutter ${widget.courseId}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.foggy),
              onPressed: () {
                context.goNamed(
                  AppRoute.ranking.name,
                  params: {
                    'courseId': widget.courseId,
                  },
                  queryParams: widget.me ? {'me': 'true'} : {},
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            final problems = state.problems;

            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: problems.length,
              itemBuilder: (context, index) {
                final problem = problems[index];
                return GestureDetector(
                  onTap: () {
                    context.goNamed(
                      AppRoute.problem.name,
                      params: {
                        'courseId': widget.courseId,
                        'problemId': problem.id,
                      },
                      queryParams: widget.me ? {'me': 'true'} : {},
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(problem.name),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
