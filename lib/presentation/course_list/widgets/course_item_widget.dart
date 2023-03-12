import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/enums/course_action.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/common_widgets/app_popup_menu_button.dart';
import 'package:code_space_client/presentation/common_widgets/show_confirm_dialog.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';

class CourseItemWidget extends StatelessWidget {
  final CourseModel course;
  final UserModel? user;
  final VoidCallback onDelete;

  const CourseItemWidget({
    Key? key,
    required this.course,
    this.user,
    required this.onDelete,
  }) : super(key: key);

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
            ? AppPopupMenuButton(
                items: CourseAction.values
                    .map(
                      (action) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        value: action,
                        child: ListTile(
                          leading: action.icon,
                          title: Text(
                            action.getName(context),
                            style: AppTextStyle.defaultFont,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  switch (value) {
                    case CourseAction.edit:
                      context.goNamed(
                        AppRoute.updateCourse.name,
                        params: {'courseId': course.id},
                      );
                      break;
                    case CourseAction.delete:
                      showConfirmDialog(
                        ctx: context,
                        title: S.of(context).delete_course,
                        content: S.of(context).confirm_delete_course,
                        onConfirm: onDelete,
                      );
                      break;
                  }
                },
              )
            : null,
      ),
    );
  }
}
