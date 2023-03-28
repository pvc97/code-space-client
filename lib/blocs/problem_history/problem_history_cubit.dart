import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/problem_history_model.dart';

part 'problem_history_state.dart';

class ProblemHistoryCubit extends Cubit<ProblemHistoryState> {
  final ProblemRepository problemRepository;

  ProblemHistoryCubit({required this.problemRepository})
      : super(ProblemHistoryState.initial());

  @override
  Future<void> close() {
    logger.d('ProblemHistoryCubit closed');
    return super.close();
  }

  void getProblemHistories({
    required String problemId,
    int? initialPage,
  }) async {
    int page = initialPage ?? state.page;

    if (state.isLoadingMore) {
      // Don't load more if already loading
      return;
    }

    emit(state.copyWith(
      isLoadingMore: true,
      stateStatus: StateStatus.loading,
    ));

    try {
      final problemHistories = await problemRepository.getProblemHistories(
        problemId: problemId,
        page: page,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        problemHistories: problemHistories,
        page: page,
        isLoadingMore: false,
        isLoadMoreDone: problemHistories.length < NetworkConstants.defaultLimit,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        stateStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void loadMoreRankings({required String problemId}) async {
    if (state.isLoadingMore || state.isLoadMoreDone) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final problemHistories = await problemRepository.getProblemHistories(
        problemId: problemId,
        page: state.page + 1,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        problemHistories: [...state.problemHistories, ...problemHistories],
        page: state.page + 1,
        isLoadingMore: false,
        isLoadMoreDone: problemHistories.length < NetworkConstants.defaultLimit,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        stateStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void refreshRankings({required String problemId}) {
    getProblemHistories(
      problemId: problemId,
      initialPage: NetworkConstants.defaultPage,
    );
  }
}
