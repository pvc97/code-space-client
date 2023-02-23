import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/language_repository.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/models/test_case_model.dart';

part 'create_problem_state.dart';

class CreateProblemCubit extends Cubit<CreateProblemState> {
  final ProblemRepository problemRepository;
  final LanguageRepository languageRepository;

  CreateProblemCubit({
    required this.problemRepository,
    required this.languageRepository,
  }) : super(CreateProblemState.initial());

  void getLanguages() async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final languages = await languageRepository.getLanguages();
      emit(state.copyWith(
        languages: languages,
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

  void addTestCase(TestCaseModel testCase) {
    final newTestCases = [testCase, ...state.testCases];
    emit(state.copyWith(testCases: newTestCases));
  }

  void removeTestCase(int index) {
    final newTestCases = [...state.testCases];
    newTestCases.removeAt(index);
    emit(state.copyWith(testCases: newTestCases));
  }

  void editTestCase(int index, TestCaseModel testCase) {
    final newTestCases = [...state.testCases];
    newTestCases[index] = testCase;
    emit(state.copyWith(testCases: newTestCases));
  }

  void updatePdfPath(String? path) {
    emit(state.copyWith(
      pdfPath: path,
      selectingPdf: false,
    ));
  }

  void createProblem({
    required String name,
    required int pointPerTestCase,
    required String courseId,
    required int languageId,
  }) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));

      final pdfPath = state.pdfPath;
      if (pdfPath == null) {
        return;
      }

      final problemId = await problemRepository.createProblem(
        name: name,
        pointPerTestCase: pointPerTestCase,
        courseId: courseId,
        languageId: languageId,
        testCases: state.testCases,
        pdfPath: pdfPath,
      );

      emit(state.copyWith(
        problemId: problemId,
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

  void setSelectingPdf(bool selecting) {
    emit(state.copyWith(selectingPdf: selecting));
  }
}
