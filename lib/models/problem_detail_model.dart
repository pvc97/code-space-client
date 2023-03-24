import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/models/test_case_model.dart';

part 'problem_detail_model.g.dart';

@JsonSerializable()
class ProblemDetailModel extends Equatable {
  final String id;
  final String name;
  final String pdfPath;
  final int pointPerTestCase;
  final String courseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LanguageModel language;
  final int numberOfTestCases;
  final Set<TestCaseModel>? testCases;

  const ProblemDetailModel({
    this.testCases,
    required this.id,
    required this.name,
    required this.pdfPath,
    required this.pointPerTestCase,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    required this.language,
    required this.numberOfTestCases,
  });

  factory ProblemDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemDetailModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      name,
      pdfPath,
      pointPerTestCase,
      courseId,
      createdAt,
      updatedAt,
      language,
      numberOfTestCases,
      testCases,
    ];
  }
}
