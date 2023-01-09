import 'package:code_space_client/models/role_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_auth_model.g.dart';

@JsonSerializable()
class UserAuthModel {
  final String userId;
  final String userName;
  final String name;
  final String email;
  final RoleType roleType;
  final String accessToken;
  final String refreshToken;

  UserAuthModel({
    required this.userId,
    required this.userName,
    required this.name,
    required this.email,
    required this.roleType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) =>
      _$UserAuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAuthModelToJson(this);
}
