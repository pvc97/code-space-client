import 'package:flutter/material.dart';

import 'package:code_space_client/constants/app_sizes.dart';

class AppPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry> items;
  final ValueChanged? onSelected;
  final Widget? icon;

  const AppPopupMenuButton({
    Key? key,
    required this.items,
    this.onSelected,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: icon,
      itemBuilder: (context) => items,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s16),
      ),
    );
  }
}
