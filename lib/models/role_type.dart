import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

enum RoleType {
  student,
  teacher,
  manager,
}

extension RoleTypeExtension on RoleType {
  String getName(BuildContext context) {
    switch (this) {
      case RoleType.student:
        return S.of(context).role_student;
      case RoleType.teacher:
        return S.of(context).role_teacher;
      case RoleType.manager:
        return S.of(context).role_manager;
    }
  }
}
