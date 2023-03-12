import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/app_exception.dart';

part 'update_course_state.dart';

class UpdateCourseCubit extends Cubit<UpdateCourseState> {
  final CourseRepository courseRepository;
  final UserRepository userRepository;

  UpdateCourseCubit({
    required this.courseRepository,
    required this.userRepository,
  }) : super(UpdateCourseState.initial());

  void getCourse({required String courseId}) async {
    emit(state.copyWith(stateStatus: StateStatus.loading));
    try {
      final course = await courseRepository.getCourse(courseId: courseId);
      emit(state.copyWith(
        course: course,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          stateStatus: StateStatus.error,
          error: e,
        ),
      );
    }
  }

  void getTeachers() async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final teachers = await userRepository.getTeachers();
      emit(state.copyWith(
        teachers: teachers,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          stateStatus: StateStatus.error,
        ),
      );
    }
  }

  void updateCourse({
    required String courseId,
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  }) async {
    emit(state.copyWith(updateStatus: StateStatus.loading));
    try {
      final course = await courseRepository.updateCourse(
        courseId: courseId,
        name: name,
        code: code,
        accessCode: accessCode,
        teacherId: teacherId,
      );
      emit(state.copyWith(
        course: course,
        updateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          updateStatus: StateStatus.error,
          error: e,
        ),
      );
    }
  }
}
