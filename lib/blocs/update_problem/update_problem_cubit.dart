import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/problem_language_repository.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/models/test_case_model.dart';

part 'update_problem_state.dart';

class UpdateProblemCubit extends Cubit<UpdateProblemState> {
  final ProblemRepository problemRepository;
  final ProblemLanguageRepository problemLanguageRepository;

  UpdateProblemCubit({
    required this.problemRepository,
    required this.problemLanguageRepository,
  }) : super(UpdateProblemState.initial());

  void getProblem(String problemId) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final problem = await problemRepository.getProblemDetail(problemId);
      emit(state.copyWith(
        problemDetail: problem,
        currentTestCases: problem.testCases ?? {},
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

  void getLanguages() async {
    try {
      emit(state.copyWith(getLanguagesStatus: StateStatus.loading));
      final languages = await problemLanguageRepository.getLanguages();
      emit(state.copyWith(
        languages: languages,
        getLanguagesStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          getLanguagesStatus: StateStatus.error,
        ),
      );
    }
  }
}
