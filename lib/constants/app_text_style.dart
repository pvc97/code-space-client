import 'package:code_space_client/constants/app_color.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static const TextStyle defaultFont = TextStyle(
    fontWeight: FontWeight.w300,
    overflow: TextOverflow.ellipsis,
    color: AppColor.black,
  );

  static final textStyle48 = defaultFont.copyWith(fontSize: 48);
  static final textStyle36 = defaultFont.copyWith(fontSize: 36);
  static final textStyle32 = defaultFont.copyWith(fontSize: 32);
  static final textStyle28 = defaultFont.copyWith(fontSize: 28);
  static final textStyle25 = defaultFont.copyWith(fontSize: 25);
  static final textStyle24 = defaultFont.copyWith(fontSize: 24);
  static final textStyle20 = defaultFont.copyWith(fontSize: 20);
  static final textStyle18 = defaultFont.copyWith(fontSize: 18);
  static final textStyle16 = defaultFont.copyWith(fontSize: 16);
  static final textStyle14 = defaultFont.copyWith(fontSize: 14);
  static final textStyle12 = defaultFont.copyWith(fontSize: 12);
  static final textStyle10 = defaultFont.copyWith(fontSize: 10);
}
