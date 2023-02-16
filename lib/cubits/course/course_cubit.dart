import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/problem_model.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository courseRepository;

  CourseCubit({required this.courseRepository}) : super(CourseState.initial());

  void getInitProblems({
    required String courseId,
    int? initialPage,
  }) async {
    int page = initialPage ?? state.page;

    if (state.isLoadingMore) {
      // Don't load more if already loading
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final problems = await courseRepository.getProblems(
        courseId: courseId,
        page: page,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        problems: problems,
        page: page,
        isLoadingMore: false,
        isLoadMoreDone: problems.length < NetworkConstants.defaultLimit,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        isLoadMoreError: true,
      ));
    }
  }

  void loadMoreProblems({
    required String courseId,
  }) async {
    if (state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final problems = await courseRepository.getProblems(
        courseId: courseId,
        page: state.page + 1,
        limit: NetworkConstants.defaultLimit,
      );

      emit(state.copyWith(
        problems: [...state.problems, ...problems],
        page: state.page + 1,
        isLoadingMore: false,
        isLoadMoreDone: problems.length < NetworkConstants.defaultLimit,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        isLoadMoreError: true,
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
}
