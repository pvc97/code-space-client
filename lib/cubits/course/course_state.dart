part of 'course_cubit.dart';

class CourseState extends BaseState {
  final List<ProblemModel> problems;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final bool isLoadMoreError;

  const CourseState({
    required this.problems,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required this.isLoadMoreError,
  });

  factory CourseState.initial() {
    return const CourseState(
      problems: [],
      page: NetworkConstants.defaultPage,
      isLoadingMore: false,
      isLoadMoreDone: false,
      isLoadMoreError: false,
    );
  }

  @override
  List<Object?> get props {
    return [
      problems,
      page,
      isLoadingMore,
      isLoadMoreDone,
      isLoadMoreError,
      ...super.props,
    ];
  }

  CourseState copyWith({
    List<ProblemModel>? problems,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    bool? isLoadMoreError,
  }) {
    return CourseState(
      problems: problems ?? this.problems,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      isLoadMoreError: isLoadMoreError ?? this.isLoadMoreError,
    );
  }
}
