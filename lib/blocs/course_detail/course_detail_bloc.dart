import 'dart:async';

import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/utils/bloc_transformer.dart';
import 'package:code_space_client/utils/event_bus/app_event.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/problem_model.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

// Get the previous event
// https://github.com/felangel/bloc/issues/1462
class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final CourseRepository courseRepository;
  final ProblemRepository problemRepository;

  final _subscriptions = <StreamSubscription>[];

  CourseDetailBloc({
    required this.courseRepository,
    required this.problemRepository,
  }) : super(CourseDetailState.initial()) {
    on<CourseDetailGetInitProblemsEvent>(_onGetInitProblems);
    on<CourseDetailSearchProblemsEvent>(
      _onSearchProblems,
      transformer: BlocTransformer.debounce(
        const Duration(milliseconds: AppConstants.searchDebounceDuration),
      ),
    );
    on<CourseDetailRefreshProblemsEvent>(_refreshProblems);
    on<CourseDetailLoadMoreProblemsEvent>(_loadMoreProblems);
    on<CourseDetailGetCourseEvent>(_onGetCourse);
    on<CourseDetailJoinCourseEvent>(_onJoinCourse);
    on<CourseDetailLeaveCourseEvent>(_onLeaveCourse);
    on<CourseDetailDeleteProblemEvent>(_onDeleteCourse);
    on<ProblemSolvedEvent>(_onProblemSolved);

    _registerToEventBus();
  }

  void _registerToEventBus() {
    _subscriptions.add(
      eventBus.on<CreateProblemSuccessEvent>().listen((event) {
        add(CourseDetailRefreshProblemsEvent(courseId: event.courseId));
      }),
    );
    _subscriptions.add(
      eventBus.on<ProblemSolvedEvent>().listen((event) {
        add(ProblemSolvedEvent(problemId: event.problemId));
      }),
    );
  }

  // NOTE: In bloc listener, I think check lastEvent is not good
  // Because lastEvent is not the event that trigger the state change
  // Example: If I have 2 events: A and B
  // on A, take 10s to complete
  // on B, take 1s to complete
  // => When add A => lastEvent = A
  // => When add B => lastEvent = B
  // But A still not complete, so when A complete lastEvent is still B
  // After googling, I think I don't need to check lastEvent,
  // I will decide what to do base on state (not event)
  // State reflect to UI and action (not event)

  // CourseDetailEvent? _lastEvent;
  // CourseDetailEvent? get lastEvent => _lastEvent;
  // @override
  // void onEvent(CourseDetailEvent event) {
  //   super.onEvent(event);
  //   _lastEvent = event;
  // }

  @override
  Future<void> close() {
    logger.d('CourseDetailBloc closed');
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    return super.close();
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
      if (e.code == StatusCodeConstants.code403) {
        logger.d('============> Unjoined course <============');
        emit(state.copyWith(
          isLoadingMore: false,
          stateStatus: StateStatus.success,
          joinedCourse: false,
        ));
        return;
      }

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
    // Disable search if not joined course because this user can't see any problems
    if (!state.joinedCourse || event.query == state.query) return;

    add(CourseDetailGetInitProblemsEvent(
      courseId: event.courseId,
      initialQuery: event.query.trim(),
      initialPage: NetworkConstants.defaultPage,
    ));
  }

  void _refreshProblems(
    CourseDetailRefreshProblemsEvent event,
    Emitter<CourseDetailState> emit,
  ) {
    add(CourseDetailGetInitProblemsEvent(
      courseId: event.courseId,
      initialQuery: state.query,
      initialPage: NetworkConstants.defaultPage,
    ));
  }

  void _loadMoreProblems(
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
      if (e.code == StatusCodeConstants.code403) {
        logger.d('============> Unjoined course <============');
        emit(state.copyWith(
          isLoadingMore: false,
          stateStatus: StateStatus.success,
          joinedCourse: false,
        ));
        return;
      }

      emit(state.copyWith(
        isLoadingMore: false,
        stateStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void _onGetCourse(
    CourseDetailGetCourseEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(state.copyWith(
      stateStatus: StateStatus.loading,
    ));

    try {
      final course = await courseRepository.getCourse(courseId: event.courseId);
      emit(state.copyWith(
        course: course,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          stateStatus: StateStatus.error,
          error: e,
        ),
      );
    }
  }

  void _onJoinCourse(
    CourseDetailJoinCourseEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(state.copyWith(
      stateStatus: StateStatus.loading,
    ));

    try {
      final success = await courseRepository.joinCourse(
        courseId: event.courseId,
        accessCode: event.accessCode,
      );
      emit(state.copyWith(
        joinedCourse: success,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          stateStatus: StateStatus.error,
          error: e,
        ),
      );
    }
  }

  void _onLeaveCourse(
    CourseDetailLeaveCourseEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(state.copyWith(
      stateStatus: StateStatus.loading,
    ));

    try {
      await courseRepository.leaveCourse(
        courseId: event.courseId,
      );
      emit(state.copyWith(
        joinedCourse: false,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          stateStatus: StateStatus.error,
          error: e,
        ),
      );
    }
  }

  void _onDeleteCourse(
    CourseDetailDeleteProblemEvent event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(state.copyWith(
      deleteStatus: StateStatus.loading,
    ));

    try {
      await problemRepository.deleteProblem(
        problemId: event.problemId,
      );

      final problems = state.problems
          .where((problem) => problem.id != event.problemId)
          .toList();

      if (state.course != null) {
        // Correct last item of the problems list
        final problemsOfCurrentPage = await courseRepository.getProblems(
          courseId: state.course!.id,
          page: state.page,
          query: state.query,
          limit: NetworkConstants.defaultLimit,
        );

        // If the last problem of current page (page with new data) is NOT the same
        // as the last problem in the old list problem then add it to the old list
        if (problemsOfCurrentPage.isNotEmpty && problems.isNotEmpty) {
          final lastProblem = problemsOfCurrentPage.last;
          if (problems.last.id != lastProblem.id) {
            problems.add(lastProblem);
          }
        }
      }

      emit(
        state.copyWith(
          problems: problems,
          deleteStatus: StateStatus.success,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          deleteStatus: StateStatus.error,
          error: e,
        ),
      );
    }
  }

  void _onProblemSolved(
    ProblemSolvedEvent event,
    Emitter<CourseDetailState> emit,
  ) {
    final problems = state.problems.map((problem) {
      if (problem.id == event.problemId) {
        return problem.copyWith(completed: true);
      }
      return problem;
    }).toList();

    emit(state.copyWith(problems: problems));
  }
}
