part of 'course_bloc.dart';

class CourseState extends BaseState {
  final List<CourseModel> courses;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final String query;
  final StateStatus deleteStatus;
  final bool onlyMyCourses;

  const CourseState({
    required this.courses,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required this.query,
    required this.onlyMyCourses,
    required this.deleteStatus,
    required super.stateStatus,
    super.error,
  });

  factory CourseState.initial() {
    return const CourseState(
      courses: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      deleteStatus: StateStatus.initial,
      onlyMyCourses: false,
      isLoadingMore: false,
      isLoadMoreDone: false,
      query: NetworkConstants.defaultQuery,
    );
  }

  CourseState copyWith({
    List<CourseModel>? courses,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    String? query,
    bool? onlyMyCourses,
    StateStatus? deleteStatus,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      query: query ?? this.query,
      onlyMyCourses: onlyMyCourses ?? this.onlyMyCourses,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      page,
      query,
      error,
      courses,
      stateStatus,
      deleteStatus,
      onlyMyCourses,
      isLoadingMore,
      isLoadMoreDone,
    ];
  }
}
