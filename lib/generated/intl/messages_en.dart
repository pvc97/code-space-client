// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Xác nhận mật khẩu"),
        "dont_have_an_account":
            MessageLookupByLibrary.simpleMessage("Bạn chưa có tài khoản?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "full_name": MessageLookupByLibrary.simpleMessage("Họ và tên"),
        "login": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "password": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
        "password_cannot_be_empty": MessageLookupByLibrary.simpleMessage(
            "Mật khẩu không được để trống"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Đăng ký"),
        "username": MessageLookupByLibrary.simpleMessage("Tài khoản"),
        "username_cannot_be_empty": MessageLookupByLibrary.simpleMessage(
            "Tài khoản không được để trống")
      };
}
