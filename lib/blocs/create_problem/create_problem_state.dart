part of 'create_problem_cubit.dart';

class CreateProblemState extends BaseState {
  final List<LanguageModel> languages;
  final String? problemId;

  const CreateProblemState({
    required this.languages,
    this.problemId,
    required super.stateStatus,
    super.error,
  });

  factory CreateProblemState.initial() {
    return const CreateProblemState(
      languages: [],
      stateStatus: StateStatus.initial,
      problemId: null,
    );
  }

  CreateProblemState copyWith({
    List<LanguageModel>? languages,
    StateStatus? stateStatus,
    AppException? error,
    String? problemId,
  }) {
    return CreateProblemState(
      languages: languages ?? this.languages,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
      problemId: problemId ?? this.problemId,
    );
  }

  @override
  List<Object?> get props => [languages, problemId, ...super.props];
}
