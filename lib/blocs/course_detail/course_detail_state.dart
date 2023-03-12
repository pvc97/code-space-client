part of 'course_detail_bloc.dart';

class CourseDetailState extends BaseState {
  final CourseModel? course;
  final List<ProblemModel> problems;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final String query;
  final bool joinedCourse;
  final StateStatus deleteStatus;

  const CourseDetailState({
    this.course,
    required this.joinedCourse,
    required this.problems,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required this.query,
    required this.deleteStatus,
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
      deleteStatus: StateStatus.initial,
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
      deleteStatus,
      stateStatus,
      error,
    ];
  }

  CourseDetailState copyWith({
    CourseModel? course,
    List<ProblemModel>? problems,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    String? query,
    StateStatus? deleteStatus,
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
      deleteStatus: deleteStatus ?? this.deleteStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
      query: query ?? this.query,
      joinedCourse: joinedCourse ?? this.joinedCourse,
    );
  }
}
