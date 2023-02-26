import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveTransitionPage {
  AdaptiveTransitionPage._();
  static Page<dynamic> create(LocalKey? key, {required Widget child}) {
    return (kIsWeb)
        ? NoTransitionPage<void>(key: key, child: child)
        : (Platform.isAndroid)
            ? MaterialPage<void>(key: key, child: child)
            : CustomTransitionPage<void>(
                key: key,
                child: child,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.linearToEaseOut,
                      reverseCurve: Curves.easeInToLinear,
                    ),
                  ),
                  child: child,
                ),
              );
  }
}
