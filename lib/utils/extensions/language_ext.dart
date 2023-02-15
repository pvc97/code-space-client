// ignore_for_file: depend_on_referenced_packages

import 'package:highlight/languages/1c.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/python.dart';

import 'package:code_space_client/models/language_model.dart';

extension LanguageExt on LanguageModel {
  get highlight {
    switch (id) {
      case 50:
        return lang1C;
      case 54:
        return cpp;
      case 62:
        return java;
      case 63:
        return javascript;
      case 71:
        return python;
      default:
        return cpp;
    }
  }
}
