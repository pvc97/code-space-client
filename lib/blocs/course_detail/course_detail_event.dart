part of 'course_detail_bloc.dart';

abstract class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();

  @override
  List<Object?> get props => [];
}

class CourseDetailGetInitProblemsEvent extends CourseDetailEvent {
  final String courseId;
  final int? initialPage;
  final String? initialQuery;

  const CourseDetailGetInitProblemsEvent({
    required this.courseId,
    this.initialPage,
    this.initialQuery,
  });

  @override
  List<Object?> get props => [courseId, initialPage, initialQuery];
}

class CourseDetailSearchProblemsEvent extends CourseDetailEvent {
  final String courseId;
  final String query;

  const CourseDetailSearchProblemsEvent({
    required this.courseId,
    required this.query,
  });

  @override
  List<Object> get props => [courseId, query];
}

class CourseDetailRefreshProblemsEvent extends CourseDetailEvent {
  final String courseId;

  const CourseDetailRefreshProblemsEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}

class CourseDetailLoadMoreProblemsEvent extends CourseDetailEvent {
  final String courseId;

  const CourseDetailLoadMoreProblemsEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}

class CourseDetailGetCourseEvent extends CourseDetailEvent {
  final String courseId;

  const CourseDetailGetCourseEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}

class CourseDetailJoinCourseEvent extends CourseDetailEvent {
  final String courseId;
  final String accessCode;

  const CourseDetailJoinCourseEvent({
    required this.courseId,
    required this.accessCode,
  });

  @override
  List<Object> get props => [courseId, accessCode];
}

class CourseDetailLeaveCourseEvent extends CourseDetailEvent {
  final String courseId;

  const CourseDetailLeaveCourseEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}

class CourseDetailDeleteProblemEvent extends CourseDetailEvent {
  final String problemId;

  const CourseDetailDeleteProblemEvent({
    required this.problemId,
  });

  @override
  List<Object> get props => [problemId];
}
