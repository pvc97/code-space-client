part of 'create_course_cubit.dart';

class CreateCourseState extends BaseState {
  final List<TeacherModel> teachers;
  final String? courseId;

  const CreateCourseState({
    required this.teachers,
    this.courseId,
    required super.stateStatus,
    super.error,
  });

  factory CreateCourseState.initial() {
    return const CreateCourseState(
      teachers: [],
      stateStatus: StateStatus.initial,
      courseId: null,
    );
  }

  CreateCourseState copyWith({
    List<TeacherModel>? teachers,
    StateStatus? stateStatus,
    AppException? error,
    String? courseId,
  }) {
    return CreateCourseState(
      teachers: teachers ?? this.teachers,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
      courseId: courseId ?? this.courseId,
    );
  }

  @override
  List<Object?> get props => [teachers, courseId, stateStatus, error];
}
