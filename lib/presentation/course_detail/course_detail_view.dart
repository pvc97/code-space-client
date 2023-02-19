import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/cubits/course/course_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/debounce.dart';
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
  int oldLength = 0;

  final TextEditingController _searchController = TextEditingController();

  final _debounce = Debounce();

  @override
  void initState() {
    super.initState();

    _initLoadMore();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initLoadMore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldLength == context.read<CourseCubit>().state.problems.length) {
        context.read<CourseCubit>().getInitProblems(courseId: widget.courseId);
      }
    });
  }

  void _loadMore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldLength == context.read<CourseCubit>().state.problems.length) {
        context.read<CourseCubit>().loadMoreProblems(courseId: widget.courseId);
      }
    });
  }

  void _searchProblem(String query) {
    // call initialQuery because we want to reset page to 1
    // and the loadmore function will use this query to load more data
    _debounce.run(debouncedAction: () {
      context.read<CourseCubit>().searchProblem(query: query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CourseCubit, CourseState>(
          listener: (context, state) {
            stateStatusListener(context, state);

            // Reference: https://github.com/tbm98/flutter_loadmore_search
            // Need dig more to understand why need oldLength :)
            // sync oldLength with problems.length to make sure ListView has newest
            // data, so loadMore will work correctly
            oldLength = state.problems.length;
          },
        ),
        BlocListener<CourseCubit, CourseState>(
          listenWhen: (previous, current) => previous.query != current.query,
          listener: (context, state) {
            context
                .read<CourseCubit>()
                .getInitProblems(courseId: widget.courseId);
          },
        ),
      ],
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
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
              builder: (context, state) {
                final problems = state.problems;

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: problems.length + 1,
                    itemBuilder: (context, index) {
                      if (index == problems.length) {
                        if (state.isLoadMoreDone ||
                            state.stateStatus == StateStatus.loading) {
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
    );
  }
}
