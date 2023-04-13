import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  // searchDebounceDuration must be at least 500ms to debounce working well
  // I've tried 300ms and if you type fast, it will not work
  static const int searchDebounceDuration = 500; // milliseconds

  static const int maxMobileWidth = 600;

  static final supportNotification = !kIsWeb && Platform.isAndroid;
}
