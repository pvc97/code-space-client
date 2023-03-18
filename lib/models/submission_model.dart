import 'package:json_annotation/json_annotation.dart';

import 'package:code_space_client/models/submission_result_model.dart';

part 'submission_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionModel {
  final String id;
  final String sourceCode;
  final int totalPoints;
  final List<SubmissionResultModel> results;

  SubmissionModel(
    this.id,
    this.sourceCode,
    this.totalPoints,
    this.results,
  );

  factory SubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionModelToJson(this);
}
