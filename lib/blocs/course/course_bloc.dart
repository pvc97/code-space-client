import 'package:code_space_client/blocs/base/base_page_state.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/repositories/course_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/utils/bloc_transformer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository courseRepository;

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
    ));

    try {
      final courses = await courseRepository.getCourses(
        page: page,
        query: query,
        limit: NetworkConstants.defaultLimit,
        me: event.onlyMyCourses,
      );

      emit(state.copyWith(
        items: courses,
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
      onlyMyCourses: event.onlyMyCourses,
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
        me: event.onlyMyCourses,
      );

      emit(state.copyWith(
        items: [...state.items, ...courses],
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
      onlyMyCourses: event.onlyMyCourses,
    ));
  }
}
