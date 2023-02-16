import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit() : super(CourseState.initial());
}
