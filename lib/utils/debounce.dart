import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  final int milliseconds;

  Debounce({
    this.milliseconds = 200,
  });

  Timer? _timer;

  cancel() {
    _timer?.cancel();
  }

  void run({
    VoidCallback? immediateAction,
    required VoidCallback debouncedAction,
  }) {
    immediateAction?.call();
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), debouncedAction);
  }
}
