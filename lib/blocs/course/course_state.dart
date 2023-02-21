part of 'course_bloc.dart';

class CourseState extends BaseState {
  final List<CourseModel> courses;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;
  final String query;

  const CourseState({
    required this.courses,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required this.query,
    required super.stateStatus,
    super.error,
  });

  factory CourseState.initial() {
    return const CourseState(
      courses: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
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
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      query: query ?? this.query,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      courses,
      page,
      isLoadingMore,
      isLoadMoreDone,
      query,
      ...super.props,
    ];
  }
}
