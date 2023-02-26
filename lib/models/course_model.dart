import 'package:code_space_client/models/teacher_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  final String id;
  final String name;
  final String code;
  final TeacherModel teacher;
  final String? accessCode;

  CourseModel({
    required this.id,
    required this.name,
    required this.code,
    required this.teacher,
    this.accessCode,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}
