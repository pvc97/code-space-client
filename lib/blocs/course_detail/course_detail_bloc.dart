import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/problem_model.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

// Debounce the search event
// https://github.com/felangel/bloc/blob/master/examples/github_search/common_github_search/lib/src/github_search_bloc/github_search_bloc.dart
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}
// Get the previous event
// https://github.com/felangel/bloc/issues/1462

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final CourseRepository courseRepository;

  CourseDetailEvent? _previousEvent;

  CourseDetailBloc({required this.courseRepository})
      : super(CourseDetailState.initial()) {
    on<CourseDetailGetInitProblemsEvent>(_onGetInitProblems);
    on<CourseDetailSearchProblemsEvent>(
      _onSearchProblems,
      transformer: debounce(
        const Duration(milliseconds: 300),
      ),
    );
    on<CourseDetailRefreshProblemsEvent>(refreshProblems);
    on<CourseDetailLoadMoreProblemsEvent>(loadMoreProblems);
  }

  CourseDetailEvent? get previousEvent => _previousEvent;

  @override
  void onEvent(CourseDetailEvent event) {
    _previousEvent = event;
    super.onEvent(event);
  }

  void _onGetInitProblems(
    CourseDetailGetInitProblemsEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    int page = event.initialPage ?? state.page;
    String query = event.initialQuery ?? state.query;

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
        courseId: event.courseId,
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

  void _onSearchProblems(
    CourseDetailSearchProblemsEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    if (event.query == state.query) return;
    add(CourseDetailGetInitProblemsEvent(
      courseId: event.courseId,
      initialQuery: event.query.trim(),
      initialPage: NetworkConstants.defaultPage,
    ));
  }

  void refreshProblems(
    CourseDetailRefreshProblemsEvent event,
    Emitter<CourseDetailState> emit,
  ) {
    add(CourseDetailGetInitProblemsEvent(
      courseId: event.courseId,
      initialQuery: state.query,
      initialPage: NetworkConstants.defaultPage,
    ));
  }

  void loadMoreProblems(
    CourseDetailLoadMoreProblemsEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    if (state.isLoadingMore || state.isLoadMoreDone) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final problems = await courseRepository.getProblems(
        courseId: event.courseId,
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
}
