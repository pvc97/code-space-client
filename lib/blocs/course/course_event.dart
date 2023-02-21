part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class GetCourseListEvent extends CourseEvent {
  final int? initialPage;
  final String? initialQuery;

  const GetCourseListEvent({
    this.initialPage,
    this.initialQuery,
  });

  @override
  List<Object?> get props => [initialPage, initialQuery];
}

class SearchCourseEvent extends CourseEvent {
  final String query;

  const SearchCourseEvent({
    required this.query,
  });

  @override
  List<Object> get props => [query];
}

class RefreshCoursesEvent extends CourseEvent {
  const RefreshCoursesEvent();

  @override
  List<Object> get props => [];
}

class LoadMoreCourseEvent extends CourseEvent {
  const LoadMoreCourseEvent();

  @override
  List<Object> get props => [];
}
