import 'package:json_annotation/json_annotation.dart';

part 'test_case_model.g.dart';

@JsonSerializable()
class TestCaseModel {
  final String stdin;
  final String expectedOutput;

  TestCaseModel({
    required this.stdin,
    required this.expectedOutput,
  });

  factory TestCaseModel.fromJson(Map<String, dynamic> json) =>
      _$TestCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TestCaseModelToJson(this);
}
