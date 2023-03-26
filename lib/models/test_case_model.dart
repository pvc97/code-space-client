import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_case_model.g.dart';

@JsonSerializable()
class TestCaseModel extends Equatable {
  final String stdin;
  final String expectedOutput;
  final bool show; // Show when wrong

  const TestCaseModel({
    required this.stdin,
    required this.expectedOutput,
    required this.show,
  });

  factory TestCaseModel.fromJson(Map<String, dynamic> json) =>
      _$TestCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TestCaseModelToJson(this);

  @override
  List<Object> get props => [stdin, expectedOutput, show];
}
