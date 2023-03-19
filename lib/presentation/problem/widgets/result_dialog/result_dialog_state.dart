part of 'result_dialog_cubit.dart';

class ResultDialogState extends Equatable {
  final String problemId;
  final int totalTestCases;
  final List<bool> results;
  final bool correctAll;

  const ResultDialogState({
    required this.problemId,
    required this.totalTestCases,
    required this.results,
    required this.correctAll,
  });

  factory ResultDialogState.initial() {
    return const ResultDialogState(
      problemId: '',
      totalTestCases: 0,
      results: [],
      correctAll: false,
    );
  }

  @override
  List<Object?> get props => [problemId, totalTestCases, results, correctAll];

  ResultDialogState copyWith({
    String? problemId,
    int? totalTestCases,
    List<bool>? results,
    bool? correctAll,
  }) {
    return ResultDialogState(
      problemId: problemId ?? this.problemId,
      totalTestCases: totalTestCases ?? this.totalTestCases,
      results: results ?? this.results,
      correctAll: correctAll ?? this.correctAll,
    );
  }
}
