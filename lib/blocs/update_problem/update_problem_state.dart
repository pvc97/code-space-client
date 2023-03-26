part of 'update_problem_cubit.dart';

class UpdateProblemState extends BaseState {
  // Current problem detail from server
  final ProblemDetailModel? problemDetail;

  final Iterable<LanguageModel> languages; // List of languages from server

  // This value to prevent user can click on pdf button multiple times when selecting pdf
  final bool selectingPdf;

  // New values to update
  final Set<TestCaseModel> currentTestCases;
  // currentTestCases contains all test cases from server and new test cases from user
  // user can add new test cases and delete test cases

  final MultipartFile? newPdfFile;

  // State status
  final StateStatus updateStatus;
  final StateStatus getLanguagesStatus;

  // final StateStatus getProblemDetailStatus;
  // I don't use getProblemDetailStatus because I use base "stateStatus" from parent class
  // for get problem detail status

  const UpdateProblemState({
    this.problemDetail,
    required this.languages,
    required this.selectingPdf,
    required this.updateStatus,
    required this.getLanguagesStatus,
    required this.currentTestCases,
    this.newPdfFile,
    required super.stateStatus,
    super.error,
  });

  factory UpdateProblemState.initial() {
    return const UpdateProblemState(
      languages: [],
      currentTestCases: {},
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
        updateStatus,
        getLanguagesStatus,
        currentTestCases,
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
    int? newLanguageId,
    Set<TestCaseModel>? currentTestCases,
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
      currentTestCases: currentTestCases ?? this.currentTestCases,
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
