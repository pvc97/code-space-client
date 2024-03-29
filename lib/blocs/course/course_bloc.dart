import 'dart:async';

import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/utils/bloc_transformer.dart';
import 'package:code_space_client/utils/event_bus/app_event.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository courseRepository;

  final _subscriptions = <StreamSubscription>[];

  CourseBloc({required this.courseRepository}) : super(CourseState.initial()) {
    on<GetCourseListEvent>(_onGetCourseList);
    on<SearchCourseEvent>(
      _onSearchCourse,
      transformer: BlocTransformer.debounce(
        const Duration(milliseconds: AppConstants.searchDebounceDuration),
      ),
    );
    on<LoadMoreCourseEvent>(_onLoadMoreCourse);
    on<RefreshCoursesEvent>(_onRefreshCourses);
    on<DeleteCourseEvent>(_onDeleteCourse);
    on<UpdateCourseSuccessEvent>(_onUpdateCourseSuccess);
    on<CreateCourseSuccessEvent>(_onCreateCourseSuccess);

    _registerToEventBus();
  }

  @override
  Future<void> close() {
    logger.d('CourseBloc closed');
    // Cancel all subscriptions
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }

  void _registerToEventBus() {
    _subscriptions.add(
      eventBus.on<UpdateCourseSuccessEvent>().listen((event) {
        add(UpdateCourseSuccessEvent(course: event.course));
      }),
    );
    _subscriptions.add(
      eventBus.on<CreateCourseSuccessEvent>().listen((event) {
        add(CreateCourseSuccessEvent(course: event.course));
      }),
    );
  }

  void _onGetCourseList(
    GetCourseListEvent event,
    Emitter<CourseState> emit,
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
      onlyMyCourses: event.onlyMyCourses,
    ));

    try {
      final courses = await courseRepository.getCourses(
        page: page,
        query: query,
        limit: NetworkConstants.defaultLimit,
        me: event.onlyMyCourses,
      );

      emit(state.copyWith(
        courses: courses,
        page: page,
        query: query,
        isLoadingMore: false,
        isLoadMoreDone: courses.length < NetworkConstants.defaultLimit,
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

  void _onSearchCourse(
    SearchCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (event.query == state.query) return;
    add(GetCourseListEvent(
      initialQuery: event.query.trim(),
      initialPage: NetworkConstants.defaultPage,
      onlyMyCourses: state.onlyMyCourses,
    ));
  }

  void _onLoadMoreCourse(
    LoadMoreCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (state.isLoadingMore || state.isLoadMoreDone) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final courses = await courseRepository.getCourses(
        page: state.page + 1,
        query: state.query,
        limit: NetworkConstants.defaultLimit,
        me: state.onlyMyCourses,
      );

      emit(state.copyWith(
        courses: [...state.courses, ...courses],
        page: state.page + 1,
        isLoadingMore: false,
        isLoadMoreDone: courses.length < NetworkConstants.defaultLimit,
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

  void _onRefreshCourses(
    RefreshCoursesEvent event,
    Emitter<CourseState> emit,
  ) {
    add(GetCourseListEvent(
      initialQuery: state.query,
      initialPage: NetworkConstants.defaultPage,
      onlyMyCourses: state.onlyMyCourses,
    ));
  }

  void _onDeleteCourse(
    DeleteCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(deleteStatus: StateStatus.loading));

    try {
      await courseRepository.deleteCourse(courseId: event.courseId);

      final courses =
          state.courses.where((course) => course.id != event.courseId).toList();

      // Correct last item of the course list
      final coursesOfCurrentPage = await courseRepository.getCourses(
        page: state.page,
        query: state.query,
        limit: NetworkConstants.defaultLimit,
        me: state.onlyMyCourses,
      );

      // If the last course of current page (page with new data) is NOT the same
      // as the last course in the old list course then add it to the old list
      if (coursesOfCurrentPage.isNotEmpty && courses.isNotEmpty) {
        final lastCourse = coursesOfCurrentPage.last;
        if (courses.last.id != lastCourse.id) {
          courses.add(lastCourse);
        }
      }

      emit(state.copyWith(
        deleteStatus: StateStatus.success,
        courses: courses,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        deleteStatus: StateStatus.error,
        error: e,
      ));
    }
  }

  void _onUpdateCourseSuccess(
    UpdateCourseSuccessEvent event,
    Emitter<CourseState> emit,
  ) {
    final courses = state.courses.map((c) {
      if (c.id == event.course.id) {
        return event.course;
      }

      return c;
    }).toList();

    emit(state.copyWith(courses: courses));
  }

  void _onCreateCourseSuccess(
    CreateCourseSuccessEvent event,
    Emitter<CourseState> emit,
  ) {
    final courses = state.courses;
    courses.insert(0, event.course);

    emit(state.copyWith(courses: courses));
  }
}
