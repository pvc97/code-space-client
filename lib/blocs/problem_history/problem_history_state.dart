part of 'problem_history_cubit.dart';

class ProblemHistoryState extends BaseState {
  final List<ProblemHistoryModel> problemHistories;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;

  const ProblemHistoryState({
    required this.problemHistories,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required super.stateStatus,
    super.error,
  });

  factory ProblemHistoryState.initial() {
    return const ProblemHistoryState(
      problemHistories: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
    );
  }

  @override
  List<Object?> get props => [
        problemHistories,
        page,
        isLoadingMore,
        isLoadMoreDone,
        stateStatus,
        error,
      ];

  ProblemHistoryState copyWith({
    List<ProblemHistoryModel>? problemHistories,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return ProblemHistoryState(
      problemHistories: problemHistories ?? this.problemHistories,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
