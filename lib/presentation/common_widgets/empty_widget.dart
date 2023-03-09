import 'package:flutter/material.dart';
import 'package:code_space_client/constants/app_images.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppImages.notFound,
          width: Sizes.s200,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s20,
          ),
          child: Text(
            message,
            style: AppTextStyle.textStyle24,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
