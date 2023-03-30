import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/utils/event_bus/app_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/problem_language_repository.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/models/test_case_model.dart';

part 'create_problem_state.dart';

class CreateProblemCubit extends Cubit<CreateProblemState> {
  final ProblemRepository problemRepository;
  final ProblemLanguageRepository problemLanguageRepository;

  CreateProblemCubit({
    required this.problemRepository,
    required this.problemLanguageRepository,
  }) : super(CreateProblemState.initial());

  void getLanguages() async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final languages = await problemLanguageRepository.getLanguages();
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

  void updatePdfPath(MultipartFile? file) {
    emit(state.copyWith(
      pdfFile: file,
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
      emit(state.copyWith(createProblemStatus: StateStatus.loading));

      final pdfFile = state.pdfFile;
      if (pdfFile == null) {
        return;
      }

      final problem = await problemRepository.createProblem(
        name: name,
        pointPerTestCase: pointPerTestCase,
        courseId: courseId,
        languageId: languageId,
        testCases: state.testCases,
        file: pdfFile,
      );

      // Can not reuse multi-part file after it is sent to server
      // So I need to reset the pdf file to null
      // https://github.com/cfug/dio/issues/482
      emit(state.copyWithDeleteMultipart(
        createProblemStatus: StateStatus.success,
      ));

      // When problem is created successfully, fire an event to update the problem list
      eventBus.fire(CreateProblemSuccessEvent(problem: problem));
    } on AppException catch (e) {
      emit(
        state.copyWithDeleteMultipart(
          error: e,
          createProblemStatus: StateStatus.error,
        ),
      );
    }
  }

  void setSelectingPdf(bool selecting) {
    emit(state.copyWith(selectingPdf: selecting));
  }
}
