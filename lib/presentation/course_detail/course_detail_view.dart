import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/cubits/course/course_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
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

    _initLoadMore();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initLoadMore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseCubit>().getInitProblems(courseId: widget.courseId);
    });
  }

  void _loadMore() {
    context.read<CourseCubit>().loadMoreProblems(courseId: widget.courseId);
  }

  void _searchProblem(String query) {
    context
        .read<CourseCubit>()
        .searchProblem(query: query, courseId: widget.courseId);
  }

  void _resetScrollPosition() {
    _scrollController.jumpTo(0);
  }

  void _refreshProblems() {
    context.read<CourseCubit>().refreshProblems(courseId: widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        const BlocListener<CourseCubit, CourseState>(
          listener: stateStatusListener,
        ),
        BlocListener<CourseCubit, CourseState>(
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
          body: RefreshIndicator(
            onRefresh: () async {
              _refreshProblems();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.s20,
                    right: Sizes.s20,
                    top: Sizes.s20,
                    bottom: Sizes.s8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).search_problem,
                    ),
                    onChanged: (value) {
                      _searchProblem(value);
                    },
                  ),
                ),
                BlocBuilder<CourseCubit, CourseState>(
                  buildWhen: (previous, current) =>
                      previous.problems != current.problems,
                  builder: (context, state) {
                    final problems = state.problems;

                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                          left: Sizes.s20,
                          right: Sizes.s20,
                          bottom: Sizes.s20,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: problems.length + 1,
                        itemBuilder: (context, index) {
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
                                queryParams: widget.me ? {'me': 'true'} : {},
                              );
                            },
                            child: Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(Sizes.s24),
                                title: Text(problem.name),
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
          ),
        ),
      ),
    );
  }
}
