part of 'create_problem_cubit.dart';

class CreateProblemState extends BaseState {
  final Iterable<LanguageModel> languages;
  final Iterable<TestCaseModel> testCases;
  final MultipartFile? pdfFile;
  final bool selectingPdf;
  final StateStatus createProblemStatus;

  const CreateProblemState({
    required this.languages,
    required this.testCases,
    required this.selectingPdf,
    required this.createProblemStatus,
    this.pdfFile,
    required super.stateStatus,
    super.error,
  });

  factory CreateProblemState.initial() {
    return const CreateProblemState(
      testCases: [],
      languages: [],
      selectingPdf: false,
      stateStatus: StateStatus.initial,
      createProblemStatus: StateStatus.initial,
      pdfFile: null,
    );
  }

  CreateProblemState copyWith({
    Iterable<LanguageModel>? languages,
    Iterable<TestCaseModel>? testCases,
    StateStatus? stateStatus,
    bool? selectingPdf,
    StateStatus? createProblemStatus,
    AppException? error,
    MultipartFile? pdfFile,
  }) {
    return CreateProblemState(
      languages: languages ?? this.languages,
      testCases: testCases ?? this.testCases,
      stateStatus: stateStatus ?? this.stateStatus,
      selectingPdf: selectingPdf ?? this.selectingPdf,
      createProblemStatus: createProblemStatus ?? this.createProblemStatus,
      error: error ?? this.error,
      pdfFile: pdfFile ?? this.pdfFile,
    );
  }

  CreateProblemState copyWithDeleteMultipart({
    StateStatus? createProblemStatus,
    AppException? error,
    MultipartFile? pdfFile,
  }) {
    return CreateProblemState(
      languages: languages,
      testCases: testCases,
      stateStatus: stateStatus,
      selectingPdf: selectingPdf,
      createProblemStatus: createProblemStatus ?? this.createProblemStatus,
      error: error ?? this.error,
      pdfFile: pdfFile,
    );
  }

  @override
  List<Object?> get props => [
        languages,
        testCases,
        pdfFile,
        selectingPdf,
        createProblemStatus,
        stateStatus,
        error
      ];
}
