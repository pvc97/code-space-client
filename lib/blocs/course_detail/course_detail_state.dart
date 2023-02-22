part of 'course_detail_bloc.dart';

class CourseDetailState extends BaseState {
  final CourseModel? course;
  final List<ProblemModel> problems;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final String query;
  final bool joinedCourse;

  const CourseDetailState({
    this.course,
    required this.joinedCourse,
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
      course: null,
      problems: [],
      joinedCourse: true,
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
      query: NetworkConstants.defaultQuery,
    );
  }

  @override
  List<Object?> get props {
    return [
      course,
      problems,
      page,
      query,
      isLoadingMore,
      isLoadMoreDone,
      joinedCourse,
      ...super.props,
    ];
  }

  CourseDetailState copyWith({
    CourseModel? course,
    List<ProblemModel>? problems,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    String? query,
    StateStatus? stateStatus,
    AppException? error,
    bool? joinedCourse,
  }) {
    return CourseDetailState(
      course: course ?? this.course,
      problems: problems ?? this.problems,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
      query: query ?? this.query,
      joinedCourse: joinedCourse ?? this.joinedCourse,
    );
  }
}
