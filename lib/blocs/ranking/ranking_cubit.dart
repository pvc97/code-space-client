import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/ranking_model.dart';

part 'ranking_state.dart';

class RankingCubit extends Cubit<RankingState> {
  final CourseRepository courseRepository;

  RankingCubit({
    required this.courseRepository,
  }) : super(RankingState.initial());

  @override
  Future<void> close() {
    logger.d('RankingCubit closed');
    return super.close();
  }

  void getRankings({
    required String courseId,
    int? initialPage,
    String? initialQuery,
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
      final rankings = await courseRepository.getRankings(
        courseId: courseId,
        page: page,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        rankings: rankings,
        page: page,
        isLoadingMore: false,
        isLoadMoreDone: rankings.length < NetworkConstants.defaultLimit,
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

  void loadMoreRankings({required String courseId}) async {
    if (state.isLoadingMore || state.isLoadMoreDone) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final rankings = await courseRepository.getRankings(
        courseId: courseId,
        page: state.page + 1,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        rankings: [...state.rankings, ...rankings],
        page: state.page + 1,
        isLoadingMore: false,
        isLoadMoreDone: rankings.length < NetworkConstants.defaultLimit,
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

  void refreshRankings({required String courseId}) {
    getRankings(courseId: courseId, initialPage: NetworkConstants.defaultPage);
  }
}
