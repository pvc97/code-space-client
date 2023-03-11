import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/models/user_model.dart';

extension UserModelExt on UserModel? {
  bool get isTeacher => this?.roleType == RoleType.teacher;
  bool get isStudent => this?.roleType == RoleType.student;
  bool get isManager => this?.roleType == RoleType.manager;
}
