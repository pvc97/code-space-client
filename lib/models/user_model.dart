import 'package:code_space_client/models/role_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id')
  final String userId;
  @JsonKey(name: 'username')
  final String userName;
  final String name;
  final String email;
  final RoleType roleType;

  UserModel({
    required this.userId,
    required this.userName,
    required this.name,
    required this.email,
    required this.roleType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
