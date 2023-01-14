import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_auth_model.g.dart';

@JsonSerializable()
class UserAuthModel extends UserModel {
  final String accessToken;
  final String refreshToken;

  UserAuthModel({
    required String userId,
    required String userName,
    required String name,
    required String email,
    required RoleType roleType,
    required this.accessToken,
    required this.refreshToken,
  }) : super(
          userId: userId,
          userName: userName,
          name: name,
          email: email,
          roleType: roleType,
        );

  factory UserAuthModel.fromJson(Map<String, dynamic> json) =>
      _$UserAuthModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserAuthModelToJson(this);
}
