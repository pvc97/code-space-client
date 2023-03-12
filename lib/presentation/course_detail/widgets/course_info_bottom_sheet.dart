import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/course_detail/widgets/leave_course_dialog.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

void showCourseInfoBottomSheet({
  required BuildContext context,
  required CourseModel course,
  required UserModel? user,
  required bool joinedCourse,
}) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Sizes.s8),
      ),
    ),
    builder: (BuildContext ctx) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.s20,
          vertical: Sizes.s12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Bootstrap.person_video,
                        color: AppColor.black,
                      ),
                      Box.w8,
                      Expanded(
                        child: SelectableText(
                          course.teacher.name,
                          style: AppTextStyle.textStyle14.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Box.h4,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Bootstrap.envelope_at,
                        color: AppColor.black,
                      ),
                      Box.w8,
                      Expanded(
                        child: SelectableText(
                          course.teacher.email,
                          style: AppTextStyle.textStyle14.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!user.isStudent && course.accessCode != null) ...[
                    Box.h4,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Bootstrap.key,
                          color: AppColor.black,
                        ),
                        Box.w8,
                        Expanded(
                          child: SelectableText(
                            course.accessCode!,
                            style: AppTextStyle.textStyle14.copyWith(
                              color: AppColor.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (joinedCourse && user.isStudent)
              ElevatedButton(
                onPressed: () async {
                  showLeaveCourseDialog(
                    context,
                    course.id,
                  ).then((_) => Navigator.pop(ctx));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                ),
                child: Text(
                  S.of(context).leave_course,
                  style: AppTextStyle.defaultFont.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
