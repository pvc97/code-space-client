import 'package:json_annotation/json_annotation.dart';

part 'submission_result_model.g.dart';

@JsonSerializable()
class SubmissionResultModel {
  final String stdin;
  final String output;
  final String expectedOutput;
  final bool correct;

  SubmissionResultModel(
    this.stdin,
    this.output,
    this.expectedOutput,
    this.correct,
  );

  factory SubmissionResultModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionResultModelToJson(this);
}
