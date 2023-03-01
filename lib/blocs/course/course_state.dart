part of 'course_bloc.dart';

class CourseState extends BasePageState<CourseModel> {
  final String query;

  const CourseState({
    required super.items,
    required super.page,
    required super.isLoadingMore,
    required super.isLoadMoreDone,
    required this.query,
    required super.stateStatus,
    super.error,
  });

  factory CourseState.initial() {
    return const CourseState(
      items: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
      query: NetworkConstants.defaultQuery,
    );
  }

  CourseState copyWith({
    List<CourseModel>? items,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    String? query,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CourseState(
      items: items ?? this.items,
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
      query,
      ...super.props,
    ];
  }

  List<CourseModel> get courses => items;
}
