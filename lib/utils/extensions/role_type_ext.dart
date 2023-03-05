import 'package:code_space_client/constants/app_images.dart';
import 'package:code_space_client/models/role_type.dart';

extension RoleTypeImageExt on RoleType {
  String get imagePath {
    switch (this) {
      case RoleType.student:
        return AppImages.student;
      case RoleType.teacher:
        return AppImages.teacher;
      case RoleType.manager:
        return AppImages.manager;
    }
  }
}
