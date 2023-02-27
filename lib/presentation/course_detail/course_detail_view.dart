import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_images.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/course_detail/widgets/join_course_dialog.dart';
import 'package:code_space_client/presentation/course_detail/widgets/leave_course_dialog.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    _scrollController.jumpTo(0);
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
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AdaptiveAppBar(
            context: context,
            centerTitle: false,
            title: Container(
              margin: const EdgeInsets.only(right: Sizes.s8),
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
                      extra: _refreshProblems,
                    );
                  },
                ),
            ],
          ),
          body: BlocSelector<CourseDetailBloc, CourseDetailState, bool>(
            selector: (state) => state.joinedCourse,
            builder: (context, joinedCourse) {
              if (!joinedCourse && user?.roleType == RoleType.student) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.s20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocSelector<CourseDetailBloc, CourseDetailState,
                            CourseModel?>(
                          selector: (state) => state.course,
                          builder: (context, course) {
                            if (course != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${S.of(context).course}: ${course.name}'),
                                  Text(
                                      '${S.of(context).course_code}: ${course.code}'),
                                  Text(
                                      '${S.of(context).teacher}: ${course.teacher.name}'),
                                  Text(
                                      '${S.of(context).email}: ${course.teacher.email}'),
                                ],
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                        AppElevatedButton(
                          text: S.of(context).join_now,
                          onPressed: () {
                            showJoinCourseDialog(context, widget.courseId);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _refreshProblems();
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: BlocSelector<CourseDetailBloc, CourseDetailState,
                          CourseModel?>(
                        selector: (state) => state.course,
                        builder: (context, course) {
                          if (course != null) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: Sizes.s24,
                                vertical: Sizes.s12,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.only(
                                      top: Sizes.s48,
                                      bottom: Sizes.s12,
                                      left: Sizes.s12,
                                      right: Sizes.s12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s8),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          AppImages.courseDescriptionBackground,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.name,
                                          style:
                                              AppTextStyle.textStyle24.copyWith(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Box.h8,
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Bootstrap.upc_scan,
                                              color: AppColor.white,
                                            ),
                                            Box.w8,
                                            Expanded(
                                              child: SelectableText(
                                                course.code,
                                                style: AppTextStyle.textStyle14
                                                    .copyWith(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(Sizes.s8),
                                            ),
                                          ),
                                          builder: (BuildContext ctx) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: Sizes.s20,
                                                vertical: Sizes.s12,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Bootstrap
                                                                  .person_video,
                                                              color: AppColor
                                                                  .black,
                                                            ),
                                                            Box.w8,
                                                            Expanded(
                                                              child:
                                                                  SelectableText(
                                                                course.teacher
                                                                    .name,
                                                                style: AppTextStyle
                                                                    .textStyle14
                                                                    .copyWith(
                                                                  color: AppColor
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Box.h4,
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Bootstrap
                                                                  .envelope_at,
                                                              color: AppColor
                                                                  .black,
                                                            ),
                                                            Box.w8,
                                                            Expanded(
                                                              child:
                                                                  SelectableText(
                                                                course.teacher
                                                                    .email,
                                                                style: AppTextStyle
                                                                    .textStyle14
                                                                    .copyWith(
                                                                  color: AppColor
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (user?.roleType !=
                                                                RoleType
                                                                    .student &&
                                                            course.accessCode !=
                                                                null) ...[
                                                          Box.h4,
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Icon(
                                                                Bootstrap.key,
                                                                color: AppColor
                                                                    .black,
                                                              ),
                                                              Box.w8,
                                                              Expanded(
                                                                child:
                                                                    SelectableText(
                                                                  course
                                                                      .accessCode!,
                                                                  style: AppTextStyle
                                                                      .textStyle14
                                                                      .copyWith(
                                                                    color: AppColor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      showLeaveCourseDialog(
                                                        context,
                                                        course.id,
                                                      ).then((_) =>
                                                          Navigator.pop(ctx));
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColor.primaryColor,
                                                    ),
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .leave_course,
                                                      style: AppTextStyle
                                                          .defaultFont
                                                          .copyWith(
                                                        color: AppColor.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Bootstrap.info_circle,
                                        color: AppColor.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    BlocBuilder<CourseDetailBloc, CourseDetailState>(
                      buildWhen: (previous, current) =>
                          previous.problems != current.problems,
                      builder: (context, state) {
                        final problems = state.problems;

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: problems.length + 1,
                            (BuildContext context, int index) {
                              if (problems.isEmpty) {
                                return Center(
                                  child: Text(
                                    S.of(context).the_course_has_no_problems,
                                    style: const TextStyle(
                                      fontSize: Sizes.s16,
                                    ),
                                  ),
                                );
                              }

                              if (index == problems.length) {
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

                              final problem = problems[index];
                              return GestureDetector(
                                onTap: () {
                                  context.goNamed(
                                    AppRoute.problem.name,
                                    params: {
                                      'courseId': widget.courseId,
                                      'problemId': problem.id,
                                    },
                                    queryParams:
                                        widget.me ? {'me': 'true'} : {},
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
                                    trailing: (user?.roleType ==
                                            RoleType.teacher)
                                        ? IconButton(
                                            onPressed: () {
                                              //TODO: Show menu
                                            },
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
