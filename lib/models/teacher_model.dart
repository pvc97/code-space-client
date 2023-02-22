import 'package:code_space_client/models/dropdown_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teacher_model.g.dart';

@JsonSerializable()
class TeacherModel implements BaseDropdownItem {
  @override
  final String id;
  final String name;
  final String email;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);

  @override
  String? get subtitle => email;

  @override
  String get title => name;
}
