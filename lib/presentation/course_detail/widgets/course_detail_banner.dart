import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_images.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/course_detail/widgets/course_info_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CourseDetailBanner extends StatelessWidget {
  const CourseDetailBanner({
    Key? key,
    required this.course,
    required this.user,
    required this.joinedCourse,
  }) : super(key: key);

  final CourseModel course;
  final UserModel? user;
  final bool joinedCourse;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Sizes.s24,
        vertical: Sizes.s12,
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(
              top: Sizes.s48,
              bottom: Sizes.s12,
              left: Sizes.s12,
              right: Sizes.s12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.s8),
              image: const DecorationImage(
                image: AssetImage(
                  AppImages.courseDescriptionBackground,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: AppTextStyle.textStyle24.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Box.h8,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Bootstrap.upc_scan,
                      color: AppColor.white,
                    ),
                    Box.w8,
                    Expanded(
                      child: SelectableText(
                        course.code,
                        style: AppTextStyle.textStyle14.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                showCourseInfoBottomSheet(
                  user: user,
                  course: course,
                  context: context,
                  joinedCourse: joinedCourse,
                );
              },
              icon: const Icon(
                Bootstrap.info_circle,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
