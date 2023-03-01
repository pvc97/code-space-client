part of 'course_detail_bloc.dart';

class CourseDetailState extends BasePageState<ProblemModel> {
  final CourseModel? course;
  final String query;
  final bool joinedCourse;

  const CourseDetailState({
    this.course,
    required this.query,
    required this.joinedCourse,
    required super.items,
    required super.page,
    required super.isLoadMoreDone,
    required super.isLoadingMore,
    required super.stateStatus,
    super.error,
  });

  factory CourseDetailState.initial() {
    return const CourseDetailState(
      course: null,
      items: [],
      joinedCourse: true,
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
      query: NetworkConstants.defaultQuery,
    );
  }

  @override
  List<Object?> get props => [query, course, joinedCourse, ...super.props];

  CourseDetailState copyWith({
    int? page,
    String? query,
    bool? joinedCourse,
    CourseModel? course,
    AppException? error,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    StateStatus? stateStatus,
    List<ProblemModel>? items,
  }) {
    return CourseDetailState(
      page: page ?? this.page,
      items: items ?? this.items,
      query: query ?? this.query,
      error: error ?? this.error,
      course: course ?? this.course,
      stateStatus: stateStatus ?? this.stateStatus,
      joinedCourse: joinedCourse ?? this.joinedCourse,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
    );
  }
}
