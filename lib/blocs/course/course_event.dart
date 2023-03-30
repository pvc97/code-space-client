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

  const SearchCourseEvent({
    required this.query,
  });

  @override
  List<Object> get props => [query];
}

class RefreshCoursesEvent extends CourseEvent {}

class LoadMoreCourseEvent extends CourseEvent {}

class DeleteCourseEvent extends CourseEvent {
  final String courseId;

  const DeleteCourseEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}

class UpdateCourseSuccessEvent extends CourseEvent {
  final CourseModel course;

  const UpdateCourseSuccessEvent({
    required this.course,
  });

  @override
  List<Object> get props => [course];
}

class CreateCourseSuccessEvent extends CourseEvent {
  final CourseModel course;

  const CreateCourseSuccessEvent({
    required this.course,
  });

  @override
  List<Object> get props => [course];
}
