import 'package:json_annotation/json_annotation.dart';

import 'package:code_space_client/models/submission_result_model.dart';

part 'submission_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionModel {
  final String id;
  final String sourceCode;
  final int totalPoint;
  final String createdBy;
  final DateTime createdAt;
  final List<SubmissionResultModel> results;
  final int totalTestCases;

  SubmissionModel(
    this.id,
    this.sourceCode,
    this.totalPoint,
    this.createdBy,
    this.createdAt,
    this.results,
    this.totalTestCases,
  );

  factory SubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$SubmissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionModelToJson(this);
}
