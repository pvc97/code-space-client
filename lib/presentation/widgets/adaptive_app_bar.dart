import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdaptiveAppBar extends AppBar {
  AdaptiveAppBar({
    Key? key,
    Widget? title,
    bool centerTitle = true,
    bool automaticallyImplyLeading = kIsWeb ? false : true,
    Color? backgroundColor,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) : super(
          key: key,
          title: title,
          centerTitle: centerTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          actions: actions,
          backgroundColor: backgroundColor,
          bottom: bottom,
        );
}
