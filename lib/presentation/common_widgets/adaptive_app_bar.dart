import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveAppBar extends AppBar {
  AdaptiveAppBar({
    required BuildContext context,
    Key? key,
    Widget? title,
    bool centerTitle = true,
    Color? backgroundColor,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) : super(
          key: key,
          title: title,
          centerTitle: centerTitle,
          actions: actions,
          backgroundColor: backgroundColor,
          bottom: bottom,
          leading: kIsWeb
              ? IconButton(
                  onPressed: () {
                    context.goNamed(AppRoute.home.name);
                  },
                  icon: const Icon(Icons.home),
                )
              : null,
        );
}
