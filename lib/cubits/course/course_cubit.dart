import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/utils/debounce.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/problem_model.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository courseRepository;

  final _debounce = Debounce();

  CourseCubit({required this.courseRepository}) : super(CourseState.initial());

  void searchProblem({
    required String query,
    required String courseId,
  }) {
    _debounce.run(debouncedAction: () {
      if (query == state.query) return;
      getInitProblems(
        courseId: courseId,
        initialQuery: query.trim(),
        initialPage: NetworkConstants.defaultPage,
      );
    });
  }

  void refreshProblems({
    required String courseId,
  }) {
    getInitProblems(
      courseId: courseId,
      initialQuery: state.query,
      initialPage: NetworkConstants.defaultPage,
    );
  }

  void getInitProblems({
    required String courseId,
    int? initialPage,
    String? initialQuery,
  }) async {
    int page = initialPage ?? state.page;
    String query = initialQuery ?? state.query;

    if (state.isLoadingMore) {
      // Don't load more if already loading
      return;
    }

    emit(state.copyWith(
      isLoadingMore: true,
      stateStatus: StateStatus.loading,
    ));

    try {
      final problems = await courseRepository.getProblems(
        courseId: courseId,
        page: page,
        query: query,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        problems: problems,
        page: page,
        query: query,
        isLoadingMore: false,
        isLoadMoreDone: problems.length < NetworkConstants.defaultLimit,
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

  void loadMoreProblems({
    required String courseId,
  }) async {
    if (state.isLoadingMore || state.isLoadMoreDone) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final problems = await courseRepository.getProblems(
        courseId: courseId,
        page: state.page + 1,
        query: state.query,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        problems: [...state.problems, ...problems],
        page: state.page + 1,
        isLoadingMore: false,
        isLoadMoreDone: problems.length < NetworkConstants.defaultLimit,
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

  void refresh({
    required String courseId,
    int? initialPage,
  }) {
    getInitProblems(
      courseId: courseId,
      initialPage: NetworkConstants.defaultPage,
    );
  }

  @override
  Future<void> close() {
    logger.d('CourseCubit closed');
    return super.close();
  }
}
