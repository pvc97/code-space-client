import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';
import 'package:flutter/material.dart';

class CourseItemWidget extends StatelessWidget {
  final CourseModel course;
  final UserModel? user;

  const CourseItemWidget({
    super.key,
    required this.course,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.s24,
          vertical: Sizes.s12,
        ),
        title: Text(
          course.name,
          style: AppTextStyle.defaultFont.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${course.code}\n${course.teacher.name}',
          style: AppTextStyle.defaultFont,
        ),
        trailing: (user.isManager)
            ? IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              )
            : null,
      ),
    );
  }
}
