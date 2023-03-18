import 'package:json_annotation/json_annotation.dart';

part 'ranking_model.g.dart';

@JsonSerializable()
class RankingModel {
  @JsonKey(name: 'name')
  final String studentName;
  final int totalPoints;

  RankingModel({
    required this.studentName,
    required this.totalPoints,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) =>
      _$RankingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankingModelToJson(this);
}
