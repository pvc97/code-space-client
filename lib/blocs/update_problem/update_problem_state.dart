part of 'update_problem_cubit.dart';

class UpdateProblemState extends BaseState {
  // Current problem detail from server
  final ProblemDetailModel? problemDetail;

  final Iterable<LanguageModel> languages; // List of languages from server

  // This value to prevent user can click on pdf button multiple times when selecting pdf
  final bool selectingPdf;

  // New values to update
  final String? newName;
  final int? newPointPerTestCase;
  final String? newLanguageId;
  final Iterable<TestCaseModel>? newTestCases;
  final MultipartFile? newPdfFile;

  // State status
  final StateStatus updateStatus;
  final StateStatus getLanguagesStatus;

  // final StateStatus getProblemDetailStatus;
  // I don't use getProblemDetailStatus because I use base state status from parent class
  // for get problem detail status

  const UpdateProblemState({
    this.problemDetail,
    required this.languages,
    required this.selectingPdf,
    required this.updateStatus,
    required this.getLanguagesStatus,
    this.newName,
    this.newPointPerTestCase,
    this.newLanguageId,
    this.newTestCases,
    this.newPdfFile,
    required super.stateStatus,
    super.error,
  });

  factory UpdateProblemState.initial() {
    return const UpdateProblemState(
      languages: [],
      selectingPdf: false,
      updateStatus: StateStatus.initial,
      getLanguagesStatus: StateStatus.initial,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [
        problemDetail,
        stateStatus,
        error,
        languages,
        selectingPdf,
        newName,
        updateStatus,
        getLanguagesStatus,
        newPointPerTestCase,
        newLanguageId,
        newTestCases,
        newPdfFile,
      ];

  UpdateProblemState copyWith({
    ProblemDetailModel? problemDetail,
    StateStatus? stateStatus,
    AppException? error,
    Iterable<LanguageModel>? languages,
    bool? selectingPdf,
    String? newName,
    int? newPointPerTestCase,
    String? newLanguageId,
    Iterable<TestCaseModel>? newTestCases,
    MultipartFile? newPdfFile,
    StateStatus? updateStatus,
    StateStatus? getLanguagesStatus,
  }) {
    return UpdateProblemState(
      problemDetail: problemDetail ?? this.problemDetail,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
      languages: languages ?? this.languages,
      selectingPdf: selectingPdf ?? this.selectingPdf,
      newName: newName ?? this.newName,
      newPointPerTestCase: newPointPerTestCase ?? this.newPointPerTestCase,
      newLanguageId: newLanguageId ?? this.newLanguageId,
      newTestCases: newTestCases ?? this.newTestCases,
      newPdfFile: newPdfFile ?? this.newPdfFile,
      updateStatus: updateStatus ?? this.updateStatus,
      getLanguagesStatus: getLanguagesStatus ?? this.getLanguagesStatus,
    );
  }

  bool get isLoading =>
      stateStatus == StateStatus.initial ||
      getLanguagesStatus == StateStatus.initial ||
      stateStatus == StateStatus.loading ||
      updateStatus == StateStatus.loading ||
      getLanguagesStatus == StateStatus.loading;
}
