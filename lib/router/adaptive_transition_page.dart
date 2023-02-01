import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveTransitionPage {
  AdaptiveTransitionPage._();
  static Page<dynamic> create(LocalKey? key, {required Widget child}) {
    return kIsWeb
        ? NoTransitionPage<void>(
            key: key,
            child: child,
          )
        : MaterialPage<void>(
            key: key,
            child: child,
          );
  }
}
