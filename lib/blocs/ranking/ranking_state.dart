part of 'ranking_cubit.dart';

class RankingState extends BaseState {
  final List<RankingModel> rankings;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;

  const RankingState({
    required this.rankings,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required super.stateStatus,
    super.error,
  });

  factory RankingState.initial() {
    return const RankingState(
      rankings: [],
      page: NetworkConstants.defaultPage,
      stateStatus: StateStatus.initial,
      isLoadingMore: false,
      isLoadMoreDone: false,
    );
  }

  @override
  List<Object?> get props =>
      [rankings, page, isLoadingMore, isLoadMoreDone, stateStatus, error];

  RankingState copyWith({
    List<RankingModel>? rankings,
    int? page,
    bool? isLoadingMore,
    bool? isLoadMoreDone,
    StateStatus? stateStatus,
    AppException? error,
  }) {
    return RankingState(
      rankings: rankings ?? this.rankings,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
      stateStatus: stateStatus ?? this.stateStatus,
      error: error ?? this.error,
    );
  }
}
