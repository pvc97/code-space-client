part of 'create_course_cubit.dart';

class CreateCourseState extends BaseState {
  final List<TeacherModel> teachers;

  const CreateCourseState({
    required this.teachers,
    required super.stateStatus,
    super.error,
  });

  factory CreateCourseState.initial() {
    return const CreateCourseState(
      teachers: [],
      stateStatus: StateStatus.initial,
    );
  }

  CreateCourseState copyWith({
    List<TeacherModel>? teachers,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return CreateCourseState(
      teachers: teachers ?? this.teachers,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [teachers, ...super.props];
}
