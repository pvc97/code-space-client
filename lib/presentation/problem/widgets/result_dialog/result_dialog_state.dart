part of 'result_dialog_cubit.dart';

class ResultDialogState extends Equatable {
  final int totalTestCases;
  final List<bool> results;

  const ResultDialogState({
    required this.totalTestCases,
    required this.results,
  });

  factory ResultDialogState.initial() {
    return const ResultDialogState(
      totalTestCases: 0,
      results: [],
    );
  }

  @override
  List<Object> get props => [totalTestCases, results];

  ResultDialogState copyWith({
    int? totalTestCases,
    List<bool>? results,
  }) {
    return ResultDialogState(
      totalTestCases: totalTestCases ?? this.totalTestCases,
      results: results ?? this.results,
    );
  }

  int get correctTestCases {
    return results.where((result) => result).length;
  }

  bool get correctAll {
    return correctTestCases == totalTestCases;
  }
}
