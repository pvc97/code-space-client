import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'result_dialog_state.dart';

class ResultDialogCubit extends Cubit<ResultDialogState> {
  ResultDialogCubit() : super(ResultDialogState.initial());

  void setTotalTestCases(int totalTestCases) {
    emit(state.copyWith(totalTestCases: totalTestCases));
  }

  void addResult(bool result) {
    emit(state.copyWith(results: [...state.results, result]));
  }

  void clearResults() {
    emit(state.copyWith(results: []));
  }
}
