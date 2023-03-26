import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'submission_result_model.g.dart';

@JsonSerializable()
class SubmissionResultModel extends Equatable {
  final String stdin;
  final String output;
  final String expectedOutput;
  final bool correct;

  const SubmissionResultModel(
    this.stdin,
    this.output,
    this.expectedOutput,
    this.correct,
  );

  factory SubmissionResultModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionResultModelToJson(this);

  @override
  List<Object> get props => [stdin, output, expectedOutput, correct];
}
