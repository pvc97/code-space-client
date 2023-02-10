part of 'problem_result_cubit.dart';

class ProblemResultState extends BaseState {
  final SubmissionModel? submission;

  const ProblemResultState({
    this.submission,
    super.stateStatus,
    super.error,
  });

  factory ProblemResultState.initial() {
    return const ProblemResultState(
      submission: null,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [submission, ...super.props];

  ProblemResultState copyWith({
    SubmissionModel? submission,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ProblemResultState(
      submission: submission ?? this.submission,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
