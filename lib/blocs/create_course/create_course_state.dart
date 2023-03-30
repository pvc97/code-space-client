part of 'create_course_cubit.dart';

class CreateCourseState extends BaseState {
  final List<TeacherModel> teachers;
  final StateStatus createCourseStatus;

  const CreateCourseState({
    required this.teachers,
    required this.createCourseStatus,
    required super.stateStatus,
    super.error,
  });

  factory CreateCourseState.initial() {
    return const CreateCourseState(
      teachers: [],
      createCourseStatus: StateStatus.initial,
      stateStatus: StateStatus.initial,
    );
  }

  CreateCourseState copyWith({
    List<TeacherModel>? teachers,
    StateStatus? stateStatus,
    StateStatus? createCourseStatus,
    AppException? error,
    String? courseId,
  }) {
    return CreateCourseState(
      teachers: teachers ?? this.teachers,
      createCourseStatus: createCourseStatus ?? this.createCourseStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [teachers, createCourseStatus, stateStatus, error];
}
