part of 'create_problem_cubit.dart';

class CreateProblemState extends BaseState {
  final Iterable<LanguageModel> languages;
  final Iterable<TestCaseModel> testCases;
  final String? problemId;
  final String? pdfPath;
  final bool selectingPdf;

  const CreateProblemState({
    required this.languages,
    required this.testCases,
    required this.selectingPdf,
    this.problemId,
    this.pdfPath,
    required super.stateStatus,
    super.error,
  });

  factory CreateProblemState.initial() {
    return const CreateProblemState(
      testCases: [],
      languages: [],
      selectingPdf: false,
      stateStatus: StateStatus.initial,
      problemId: null,
      pdfPath: null,
    );
  }

  CreateProblemState copyWith({
    Iterable<LanguageModel>? languages,
    Iterable<TestCaseModel>? testCases,
    StateStatus? stateStatus,
    bool? selectingPdf,
    AppException? error,
    String? problemId,
    String? pdfPath,
  }) {
    return CreateProblemState(
      languages: languages ?? this.languages,
      testCases: testCases ?? this.testCases,
      stateStatus: stateStatus ?? this.stateStatus,
      selectingPdf: selectingPdf ?? this.selectingPdf,
      error: error ?? this.error,
      problemId: problemId ?? this.problemId,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }

  @override
  List<Object?> get props =>
      [languages, testCases, problemId, pdfPath, selectingPdf, ...super.props];
}
