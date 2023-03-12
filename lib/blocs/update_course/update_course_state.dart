part of 'update_course_cubit.dart';

class UpdateCourseState extends BaseState {
  // stateStatus from BaseState is used to manage the state of get account info
  final CourseModel? course;
  final List<TeacherModel> teachers;
  final StateStatus updateStatus;
  final StateStatus getTeachersStatus;

  const UpdateCourseState({
    required this.teachers,
    required this.course,
    required this.updateStatus,
    required this.getTeachersStatus,
    required super.stateStatus,
    super.error,
  });

  factory UpdateCourseState.initial() {
    return const UpdateCourseState(
      course: null,
      teachers: [],
      stateStatus: StateStatus.initial,
      updateStatus: StateStatus.initial,
      getTeachersStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props =>
      [course, teachers, stateStatus, updateStatus, getTeachersStatus, error];

  UpdateCourseState copyWith({
    CourseModel? course,
    List<TeacherModel>? teachers,
    StateStatus? stateStatus,
    StateStatus? updateStatus,
    StateStatus? getTeachersStatus,
    AppException? error,
  }) {
    return UpdateCourseState(
      course: course ?? this.course,
      teachers: teachers ?? this.teachers,
      updateStatus: updateStatus ?? this.updateStatus,
      getTeachersStatus: getTeachersStatus ?? this.getTeachersStatus,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }

  bool get isLoading =>
      stateStatus == StateStatus.loading ||
      updateStatus == StateStatus.loading ||
      getTeachersStatus == StateStatus.loading;
}
