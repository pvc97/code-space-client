part of 'problem_cubit.dart';

class ProblemState extends BaseState {
  final String? submissionId;
  final ProblemDetailModel? problemDetail;

  const ProblemState({
    this.submissionId,
    this.problemDetail,
    super.stateStatus,
    super.error,
  });

  factory ProblemState.initial() {
    return const ProblemState(
      submissionId: null,
      problemDetail: null,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [submissionId, problemDetail, ...super.props];

  ProblemState copyWith({
    String? submissionId,
    ProblemDetailModel? problemDetail,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ProblemState(
      submissionId: submissionId ?? this.submissionId,
      stateStatus: stateStatus ?? this.stateStatus,
      problemDetail: problemDetail ?? this.problemDetail,
      error: error ?? this.error,
    );
  }
}
