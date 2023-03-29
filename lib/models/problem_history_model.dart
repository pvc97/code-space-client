import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:code_space_client/models/language_model.dart';

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
  final LanguageModel language;

  const ProblemHistoryModel({
    required this.submissionId,
    required this.sourceCode,
    required this.createdAt,
    required this.numberOfTestCases,
    required this.correctTestCases,
    required this.pointPerTestCase,
    required this.language,
  });

  @override
  List<Object?> get props => [
        submissionId,
        sourceCode,
        createdAt,
        numberOfTestCases,
        correctTestCases,
        pointPerTestCase,
        language,
      ];

  bool get completed => numberOfTestCases == correctTestCases;
  int get totalPoints => numberOfTestCases * pointPerTestCase;

  factory ProblemHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemHistoryModelToJson(this);
}
