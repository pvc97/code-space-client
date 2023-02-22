import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/user_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/teacher_model.dart';

part 'create_course_state.dart';

class CreateCourseCubit extends Cubit<CreateCourseState> {
  final UserRepository userRepository;
  CreateCourseCubit({
    required this.userRepository,
  }) : super(CreateCourseState.initial());

  void fetchTeachers() async {
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
}
