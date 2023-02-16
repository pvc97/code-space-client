import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveTransitionPage {
  AdaptiveTransitionPage._();
  static Page<dynamic> create(LocalKey? key, {required Widget child}) {
    return (Platform.isAndroid || Platform.isIOS)
        ? MaterialPage<void>(
            key: key,
            child: child,
          )
        : NoTransitionPage<void>(
            key: key,
            child: child,
          );
  }
}
