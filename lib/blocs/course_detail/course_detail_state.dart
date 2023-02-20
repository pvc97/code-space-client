part of 'course_detail_bloc.dart';

class CourseDetailState extends BaseState {
  final List<ProblemModel> problems;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final String query;

  const CourseDetailState({
    required this.problems,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required this.query,
    required super.stateStatus,
    super.error,
  });

  factory CourseDetailState.initial() {
    return const CourseDetailState(
      problems: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
      query: '',
    );
  }

  @override
  List<Object?> get props {
    return [
      problems,
      page,
      query,
      isLoadingMore,
      isLoadMoreDone,
      ...super.props,
    ];
  }

  CourseDetailState copyWith({
    List<ProblemModel>? problems,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    String? query,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CourseDetailState(
      problems: problems ?? this.problems,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}
