import 'dart:io';
import 'package:flutter/cupertino.dart';
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
            : CupertinoPage<void>(key: key, child: child);
  }
}
