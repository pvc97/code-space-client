import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'problem_history_model.g.dart';

@JsonSerializable()
class ProblemHistoryModel extends Equatable {
  @JsonKey(name: 'id')
  final String submissionId;
  final String sourceCode;
  final DateTime createdAt;
  final int numberOfTestCases;
  final int correctTestCases;
  final int pointPerTestCase;

  const ProblemHistoryModel({
    required this.submissionId,
    required this.sourceCode,
    required this.createdAt,
    required this.numberOfTestCases,
    required this.correctTestCases,
    required this.pointPerTestCase,
  });

  @override
  List<Object?> get props => [
        submissionId,
        sourceCode,
        createdAt,
        numberOfTestCases,
        correctTestCases,
        pointPerTestCase,
      ];

  bool get completed => numberOfTestCases == correctTestCases;
  int get totalPoints => numberOfTestCases * pointPerTestCase;

  factory ProblemHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemHistoryModelToJson(this);
}
