import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:code_space_client/models/role_type.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: 'id')
  final String userId;
  @JsonKey(name: 'username')
  final String userName;
  final String name;
  final String email;
  final RoleType roleType;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.name,
    required this.email,
    required this.roleType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object> get props {
    return [
      userId,
      userName,
      name,
      email,
      roleType,
    ];
  }
}
