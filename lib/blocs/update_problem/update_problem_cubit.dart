import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';
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

  void addTestCase(TestCaseModel testCase) {
    final newTestCases = {testCase, ...state.currentTestCases};
    emit(state.copyWith(currentTestCases: newTestCases));
  }

  void editTestCase(int index, TestCaseModel testCase) {
    final newTestCases = state.currentTestCases.toList();

    newTestCases[index] = testCase;

    emit(state.copyWith(currentTestCases: newTestCases.toSet()));
  }

  void removeTestCase(int index) {
    final newTestCases = state.currentTestCases.toList();
    newTestCases.removeAt(index);
    emit(state.copyWith(currentTestCases: newTestCases.toSet()));
  }

  void setSelectingPdf(bool selecting) {
    emit(state.copyWith(selectingPdf: selecting));
  }

  void updatePdfPath(MultipartFile? file) {
    emit(state.copyWith(
      newPdfFile: file,
      selectingPdf: false,
    ));
  }

  void updateProblem() async {
    try {
      emit(state.copyWith(updateStatus: StateStatus.loading));
      // // final languages = await problemLanguageRepository.getLanguages();

      // // final testCases = {
      // //   ...state.currentTestCases,
      // //   ...?state.problemDetail?.testCases
      // // };

      // // if (testCases.length == state.currentTestCases.length)

      // emit(state.copyWith(
      //   updateStatus: StateStatus.success,
      // ));
      throw AppException(message: S.of(AppRouter.context).accounts);
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          updateStatus: StateStatus.error,
        ),
      );
    }
  }
}
