import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/course/course_bloc.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/empty_widget.dart';
import 'package:code_space_client/presentation/course_list/widgets/course_item_widget.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    context.read<CourseBloc>().add(SearchCourseEvent(query: query));
  }

  void _loadMore() {
    context.read<CourseBloc>().add(LoadMoreCourseEvent());
  }

  void _resetScrollPosition() {
    // Have to check if the scrollController has clients
    // Because if the user is searching and the search result is empty
    // so _scrollController doesn't have any clients
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _refreshCourses() {
    context.read<CourseBloc>().add(RefreshCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);
    return MultiBlocListener(
      listeners: [
        BlocListener<CourseBloc, CourseState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        BlocListener<CourseBloc, CourseState>(
          listenWhen: (previous, current) {
            return previous.deleteStatus != current.deleteStatus;
          },
          listener: (context, state) {
            stateStatusListener(
              context,
              state,
              stateStatus: state.deleteStatus,
              onSuccess: () {
                EasyLoading.showSuccess(
                  S.of(context).delete_course_success,
                  dismissOnTap: true,
                );
              },
            );
          },
        ),
        BlocListener<CourseBloc, CourseState>(
          listenWhen: (previous, current) => previous.query != current.query,
          listener: (context, state) {
            _resetScrollPosition();
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          showHomeButton: false,
          title: Container(
            margin: EdgeInsets.only(
                left: Sizes.s20,
                right: (user?.roleType == RoleType.manager) ? 0 : Sizes.s20),
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
        body: RefreshIndicator(
          onRefresh: () async {
            _refreshCourses();
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              BlocBuilder<CourseBloc, CourseState>(
                buildWhen: (previous, current) =>
                    previous.courses != current.courses,
                builder: (context, state) {
                  final courses = state.courses;

                  if (state.stateStatus == StateStatus.initial) {
                    return const SliverToBoxAdapter();
                  }

                  if (courses.isEmpty) {
                    String message;
                    if (state.query.trim().isEmpty) {
                      message = widget.me
                          ? S.of(context).you_don_t_have_any_course
                          : S.of(context).no_courses_have_been_created_yet;
                    } else {
                      message = S.of(context).course_not_found;
                    }

                    return SliverFillRemaining(
                      child: Center(
                        child: EmptyWidget(message: message),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.s12,
                      horizontal: Sizes.s20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: courses.length + 1,
                        (context, index) {
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
                            child: CourseItemWidget(
                              user: user,
                              course: course,
                              onDelete: () {
                                context
                                    .read<CourseBloc>()
                                    .add(DeleteCourseEvent(
                                      courseId: course.id,
                                    ));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
