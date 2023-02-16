import 'package:json_annotation/json_annotation.dart';

part 'problem_model.g.dart';

@JsonSerializable()
class ProblemModel {
  final String id;
  final String name;

  ProblemModel({
    required this.id,
    required this.name,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemModelToJson(this);
}
