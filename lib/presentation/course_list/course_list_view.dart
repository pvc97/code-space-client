import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/course/course_bloc.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CourseListView extends StatefulWidget {
  final bool me;

  const CourseListView({
    Key? key,
    required this.me,
  }) : super(key: key);

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  void _searchCourse(String query) {
    context.read<CourseBloc>().add(SearchCourseEvent(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        context: context,
        backgroundColor: widget.me ? Colors.green : Colors.pink,
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).search_course,
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (value) {
            _searchCourse(value);
          },
        ),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        buildWhen: (previous, current) => previous.courses != current.courses,
        builder: (context, state) {
          final courses = state.courses;

          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: courses.length + 1,
            itemBuilder: (context, index) {
              if (index == courses.length) {
                // // Check stateStatus to avoid infinite loop call loadMore
                if (state.isLoadMoreDone ||
                    state.stateStatus != StateStatus.success) {
                  return const SizedBox.shrink();
                }

                // // Loadmore when last item is rendered
                // _loadMore();

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final course = courses[index];
              return GestureDetector(
                onTap: () {
                  context.goNamed(
                    AppRoute.courseDetail.name,
                    params: {'courseId': course.id},
                    queryParams: widget.me ? {'me': 'true'} : {},
                  );
                },
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(Sizes.s24),
                    leading: Text(course.name),
                    title: Text('Teacher: ${course.teacher.name}'),
                    trailing: Text(course.code),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
