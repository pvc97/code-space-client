// import 'package:code_space_client/router/app_router.dart';
// import 'package:flutter/foundation.dart';
// import 'package:go_router/go_router.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class AdaptiveAppBar extends AppBar {
  AdaptiveAppBar({
    required BuildContext context,
    Key? key,
    Widget? title,
    bool centerTitle = true,
    Color? backgroundColor,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
    bool showHomeButton = true, // Only for web
  }) : super(
          key: key,
          title: title,
          centerTitle: centerTitle,
          actions: actions,
          backgroundColor: backgroundColor,
          bottom: bottom,
          titleSpacing: 0, // Remove space between title and leading and actions
          leading: showHomeButton && kIsWeb
              ? IconButton(
                  onPressed: () {
                    context.goNamed(AppRoute.courses.name);
                  },
                  icon: const Icon(Bootstrap.house_door),
                )
              : null,
        );
}
