part of 'problem_cubit.dart';

class ProblemState extends BaseState {
  final String? submissionId;

  const ProblemState({
    this.submissionId,
    super.stateStatus,
    super.error,
  });

  factory ProblemState.initial() {
    return const ProblemState(
      submissionId: null,
      stateStatus: StateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [submissionId, ...super.props];

  ProblemState copyWith({
    String? submissionId,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ProblemState(
      submissionId: submissionId ?? this.submissionId,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
