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