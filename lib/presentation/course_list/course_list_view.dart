import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/course/course_bloc.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    logger.d('CourseListView dispose: me =  ${widget.me}');
    super.dispose();
  }

  void _searchCourse(String query) {
    context
        .read<CourseBloc>()
        .add(SearchCourseEvent(query: query, onlyMyCourses: widget.me));
  }

  void _loadMore() {
    context
        .read<CourseBloc>()
        .add(LoadMoreCourseEvent(onlyMyCourses: widget.me));
  }

  void _resetScrollPosition() {
    _scrollController.jumpTo(0);
  }

  void _refreshCourses() {
    context
        .read<CourseBloc>()
        .add(RefreshCoursesEvent(onlyMyCourses: widget.me));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);
    return MultiBlocListener(
      listeners: [
        const BlocListener<CourseBloc, CourseState>(
          listener: stateStatusListener,
        ),
        BlocListener<CourseBloc, CourseState>(
          listenWhen: (previous, current) => previous.query != current.query,
          listener: (context, state) {
            _resetScrollPosition();
          },
        ),
      ],
      child: Scaffold(
        appBar: AdaptiveAppBar(
          context: context,
          showHomeButton: false,
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
            child: TextField(
              decoration: InputDecoration(
                // border: InputBorder.none,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: S.of(context).search_course,
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                // Make textfield height smaller
                isDense: true,
                contentPadding: const EdgeInsets.all(Sizes.s8),
              ),
              onChanged: (value) {
                _searchCourse(value);
              },
            ),
          ),
          actions: [
            if (user?.roleType == RoleType.manager)
              IconButton(
                onPressed: () {
                  context.goNamed(AppRoute.createCourse.name);
                },
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: BlocBuilder<CourseBloc, CourseState>(
          buildWhen: (previous, current) => previous.courses != current.courses,
          builder: (context, state) {
            final courses = state.courses;

            return RefreshIndicator(
              onRefresh: () async {
                _refreshCourses();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.s12,
                  horizontal: Sizes.s20,
                ),
                itemCount: courses.length + 1,
                itemBuilder: (context, index) {
                  if (index == courses.length) {
                    // Check stateStatus to avoid infinite loop call loadMore
                    if (state.isLoadMoreDone ||
                        state.stateStatus != StateStatus.success) {
                      return const SizedBox.shrink();
                    }

                    // Loadmore when last item is rendered
                    _loadMore();

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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.s24,
                          vertical: Sizes.s12,
                        ),
                        title: Text(
                          course.name,
                          style: AppTextStyle.defaultFont.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${course.code}\n${course.teacher.name}',
                          style: AppTextStyle.defaultFont,
                        ),
                        trailing: (user?.roleType == RoleType.manager)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
