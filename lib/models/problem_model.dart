import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'problem_model.g.dart';

@JsonSerializable()
class ProblemModel extends Equatable {
  final String id;
  final String name;
  final bool completed;

  const ProblemModel({
    required this.id,
    required this.name,
    required this.completed,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemModelToJson(this);

  @override
  List<Object?> get props => [id, name, completed];

  ProblemModel copyWith({
    String? id,
    String? name,
    bool? completed,
  }) {
    return ProblemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }
}
