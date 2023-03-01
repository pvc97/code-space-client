import 'package:json_annotation/json_annotation.dart';

part 'ranking_model.g.dart';

@JsonSerializable()
class RankingModel {
  final String studentName;
  final int totalPoint;

  RankingModel({
    required this.studentName,
    required this.totalPoint,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) =>
      _$RankingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RankingModelToJson(this);
}
