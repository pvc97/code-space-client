import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/empty_widget.dart';
import 'package:code_space_client/presentation/course_detail/widgets/course_detail_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/course_detail/widgets/join_course_dialog.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:icons_plus/icons_plus.dart';

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
  // There are two possible time to call loadMore:
  // 1 - User scrollController to detect when user scroll to the end of list
  // 2 - When listView.builder render last item
  // I think way 1 is not good because on the first time if data length is less than limit
  // and height of listview is less than screen height
  // then user will never be able to load more data
  // So I use way 2

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    context
        .read<CourseDetailBloc>()
        .add(CourseDetailLoadMoreProblemsEvent(courseId: widget.courseId));
  }

  void _searchProblem(String query) {
    context.read<CourseDetailBloc>().add(CourseDetailSearchProblemsEvent(
        query: query, courseId: widget.courseId));
  }

  void _resetScrollPosition() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _refreshProblems() {
    context
        .read<CourseDetailBloc>()
        .add(CourseDetailRefreshProblemsEvent(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);
    return MultiBlocListener(
      listeners: [
        const BlocListener<CourseDetailBloc, CourseDetailState>(
          listener: stateStatusListener,
        ),
        BlocListener<CourseDetailBloc, CourseDetailState>(
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
          centerTitle: false,
          title: Container(
            margin: const EdgeInsets.only(right: Sizes.s4),
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.search),
                hintText: S.of(context).search_problem,
                fillColor: Colors.white,
                filled: true,
                // Make textfield height smaller
                isDense: true,
                contentPadding: const EdgeInsets.all(Sizes.s8),
              ),
              controller: _searchController,
              onChanged: (value) {
                _searchProblem(value);
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.military_tech),
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
            if (user?.roleType == RoleType.teacher)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.goNamed(
                    AppRoute.createProblem.name,
                    params: {'courseId': widget.courseId},
                    queryParams: widget.me ? {'me': 'true'} : {},
                  );
                },
              ),
          ],
        ),
        body: BlocSelector<CourseDetailBloc, CourseDetailState, bool>(
          selector: (state) => state.joinedCourse,
          builder: (context, joinedCourse) {
            if (!joinedCourse) {
              return BlocSelector<CourseDetailBloc, CourseDetailState,
                  CourseModel?>(
                selector: (state) => state.course,
                builder: (context, course) {
                  if (course == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      CourseDetailBanner(
                        user: user,
                        course: course,
                        joinedCourse: joinedCourse,
                      ),
                      user?.roleType == RoleType.student
                          ? AppElevatedButton(
                              text: S.of(context).join_now,
                              onPressed: () {
                                showJoinCourseDialog(context, widget.courseId);
                              },
                            )
                          : user?.roleType == RoleType.teacher
                              ? Expanded(
                                  child: Center(
                                    child: EmptyWidget(
                                      message: S
                                          .of(context)
                                          .you_are_not_the_teacher_of_this_course,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ],
                  );
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _refreshProblems();
              },
              // To make refresh indicator work without listview take all space
              // just set physics to AlwaysScrollableScrollPhysics
              // and if I want this physics with BoundaryScrollPhysics
              // I can set global physics in main
              // or wrap AlwaysScrollableScrollPhysics inside BouncingScrollPhysics
              // like: BouncingScrollPhysics( parent: AlwaysScrollableScrollPhysics(),)
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: BlocSelector<CourseDetailBloc, CourseDetailState,
                        CourseModel?>(
                      selector: (state) => state.course,
                      builder: (context, course) {
                        if (course != null) {
                          return CourseDetailBanner(
                            user: user,
                            course: course,
                            joinedCourse: joinedCourse,
                          );
                        }

                        return Box.shrink;
                      },
                    ),
                  ),
                  BlocBuilder<CourseDetailBloc, CourseDetailState>(
                    buildWhen: (previous, current) =>
                        previous.problems != current.problems,
                    builder: (context, state) {
                      final problems = state.problems;

                      if (problems.isEmpty) {
                        if (!state.joinedCourse ||
                            state.stateStatus == StateStatus.initial) {
                          return const SliverToBoxAdapter();
                        }

                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: EmptyWidget(
                                message: S.of(context).no_problems_found),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: problems.length + 1,
                          (BuildContext context, int index) {
                            if (index == problems.length) {
                              // Check stateStatus to avoid infinite loop call loadMore
                              if (state.isLoadMoreDone ||
                                  state.stateStatus != StateStatus.success) {
                                return Box.shrink;
                              }

                              // Loadmore when last item is rendered
                              _loadMore();

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

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
                                margin: const EdgeInsets.only(
                                  left: Sizes.s24,
                                  right: Sizes.s24,
                                  bottom: Sizes.s8,
                                ),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.all(Sizes.s24),
                                  title: Text(problem.name),
                                  trailing: (user?.roleType == RoleType.teacher)
                                      ? IconButton(
                                          onPressed: () {
                                            //TODO: Show menu
                                          },
                                          icon: const Icon(Icons.more_vert),
                                        )
                                      : (user?.roleType == RoleType.student &&
                                              problem.completed)
                                          ? const Icon(
                                              Bootstrap.check2_circle,
                                              color: AppColor.primaryColor,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
