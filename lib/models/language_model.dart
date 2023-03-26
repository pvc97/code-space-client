import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:code_space_client/models/dropdown_item.dart';

part 'language_model.g.dart';

@JsonSerializable()
class LanguageModel extends Equatable implements BaseDropdownItem {
  @JsonKey(name: 'id')
  final int languageId;
  final String name;
  const LanguageModel({
    required this.languageId,
    required this.name,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageModelToJson(this);

  @override
  String get id => languageId.toString();

  @override
  String get title => name;

  @override
  String? get subtitle => null;

  @override
  List<Object> get props => [languageId, name];
}
