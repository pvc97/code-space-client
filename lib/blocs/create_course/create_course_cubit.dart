import 'package:code_space_client/blocs/course/course_bloc.dart';
import 'package:code_space_client/utils/event_bus/app_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/teacher_model.dart';

part 'create_course_state.dart';

class CreateCourseCubit extends Cubit<CreateCourseState> {
  final UserRepository userRepository;
  final CourseRepository courseRepository;

  CreateCourseCubit({
    required this.userRepository,
    required this.courseRepository,
  }) : super(CreateCourseState.initial());

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

  void createCourse({
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  }) async {
    try {
      emit(state.copyWith(
        createCourseStatus: StateStatus.loading,
      ));

      final course = await courseRepository.createCourse(
        name: name,
        code: code,
        accessCode: accessCode,
        teacherId: teacherId,
      );

      emit(state.copyWith(
        createCourseStatus: StateStatus.success,
      ));
      eventBus.fire(CreateCourseSuccessEvent(course: course));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          createCourseStatus: StateStatus.error,
        ),
      );
    }
  }
}
