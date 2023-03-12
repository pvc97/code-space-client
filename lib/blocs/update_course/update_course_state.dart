part of 'update_course_cubit.dart';

class UpdateCourseState extends BaseState {
  // stateStatus from BaseState is used to manage the state of get account info
  final CourseModel? course;
  final StateStatus updateStatus;

  const UpdateCourseState({
    required this.course,
    required this.updateStatus,
    required super.stateStatus,
    super.error,
  });

  factory UpdateCourseState.initial() {
    return const UpdateCourseState(
      course: null,
      stateStatus: StateStatus.initial,
      updateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [course, stateStatus, updateStatus, error];

  UpdateCourseState copyWith({
    CourseModel? course,
    StateStatus? stateStatus,
    StateStatus? updateStatus,
    AppException? error,
  }) {
    return UpdateCourseState(
      course: course ?? this.course,
      updateStatus: updateStatus ?? this.updateStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
