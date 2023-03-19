import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/utils/event_bus/app_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'result_dialog_state.dart';

class ResultDialogCubit extends Cubit<ResultDialogState> {
  ResultDialogCubit() : super(ResultDialogState.initial());

  void setInitialData({
    required String problemId,
    required int totalTestCases,
  }) {
    emit(state.copyWith(problemId: problemId, totalTestCases: totalTestCases));
  }

  void addResult(bool result) {
    emit(state.copyWith(results: [...state.results, result]));

    // Check if all test cases are correct
    final correctAll = state.results.every((result) => result) &&
        state.results.length == state.totalTestCases;

    emit(state.copyWith(correctAll: correctAll));

    if (correctAll) {
      eventBus.fire(ProblemSolvedEvent(problemId: state.problemId));
    }
  }

  void clearResults() {
    emit(state.copyWith(results: []));
  }
}
