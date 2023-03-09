part of 'problem_cubit.dart';

enum ProblemTab {
  pdf,
  code,
}

class ProblemState extends BaseState {
  final String? submissionId;
  final ProblemDetailModel? problemDetail;
  final ProblemTab problemTab;

  const ProblemState({
    required this.problemTab,
    this.submissionId,
    this.problemDetail,
    required super.stateStatus,
    super.error,
  });

  factory ProblemState.initial() {
    return const ProblemState(
      problemTab: ProblemTab.pdf,
      submissionId: null,
      problemDetail: null,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props =>
      [submissionId, problemDetail, problemTab, stateStatus, error];

  ProblemState copyWith({
    ProblemTab? problemTab,
    String? submissionId,
    ProblemDetailModel? problemDetail,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ProblemState(
      problemTab: problemTab ?? this.problemTab,
      submissionId: submissionId ?? this.submissionId,
      stateStatus: stateStatus ?? this.stateStatus,
      problemDetail: problemDetail ?? this.problemDetail,
      error: error ?? this.error,
    );
  }
}
