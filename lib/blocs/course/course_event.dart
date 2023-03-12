part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class GetCourseListEvent extends CourseEvent {
  final int? initialPage;
  final String? initialQuery;
  final bool onlyMyCourses;

  const GetCourseListEvent({
    this.initialPage,
    this.initialQuery,
    required this.onlyMyCourses,
  });

  @override
  List<Object?> get props => [initialPage, initialQuery, onlyMyCourses];
}

class SearchCourseEvent extends CourseEvent {
  final String query;
  final bool onlyMyCourses;

  const SearchCourseEvent({
    required this.query,
    required this.onlyMyCourses,
  });

  @override
  List<Object> get props => [query, onlyMyCourses];
}

class RefreshCoursesEvent extends CourseEvent {
  final bool onlyMyCourses;

  const RefreshCoursesEvent({
    required this.onlyMyCourses,
  });

  @override
  List<Object> get props => [onlyMyCourses];
}

class LoadMoreCourseEvent extends CourseEvent {
  final bool onlyMyCourses;

  const LoadMoreCourseEvent({required this.onlyMyCourses});

  @override
  List<Object> get props => [onlyMyCourses];
}

class DeleteCourseEvent extends CourseEvent {
  final String courseId;
  final bool onlyMyCourses;

  const DeleteCourseEvent({
    required this.courseId,
    required this.onlyMyCourses,
  });

  @override
  List<Object> get props => [courseId];
}
