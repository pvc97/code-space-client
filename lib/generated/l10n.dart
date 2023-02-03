// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Tài khoản`
  String get username {
    return Intl.message(
      'Tài khoản',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu`
  String get password {
    return Intl.message(
      'Mật khẩu',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Đăng nhập`
  String get login {
    return Intl.message(
      'Đăng nhập',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Bạn chưa có tài khoản?`
  String get dont_have_an_account {
    return Intl.message(
      'Bạn chưa có tài khoản?',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Đăng ký`
  String get sign_up {
    return Intl.message(
      'Đăng ký',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Họ và tên`
  String get full_name {
    return Intl.message(
      'Họ và tên',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Xác nhận mật khẩu`
  String get confirm_password {
    return Intl.message(
      'Xác nhận mật khẩu',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu không được để trống`
  String get password_cannot_be_empty {
    return Intl.message(
      'Mật khẩu không được để trống',
      name: 'password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Tài khoản không được để trống`
  String get username_cannot_be_empty {
    return Intl.message(
      'Tài khoản không được để trống',
      name: 'username_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Không có kết nối mạng`
  String get no_network {
    return Intl.message(
      'Không có kết nối mạng',
      name: 'no_network',
      desc: '',
      args: [],
    );
  }

  /// `Họ và tên không được để trống`
  String get full_name_cannot_be_empty {
    return Intl.message(
      'Họ và tên không được để trống',
      name: 'full_name_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Email không được để trống`
  String get email_cannot_be_empty {
    return Intl.message(
      'Email không được để trống',
      name: 'email_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu không khớp`
  String get passwords_do_not_match {
    return Intl.message(
      'Mật khẩu không khớp',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Danh sách khóa học`
  String get course_list {
    return Intl.message(
      'Danh sách khóa học',
      name: 'course_list',
      desc: '',
      args: [],
    );
  }

  /// `Khóa học của tôi`
  String get my_courses {
    return Intl.message(
      'Khóa học của tôi',
      name: 'my_courses',
      desc: '',
      args: [],
    );
  }

  /// `Hồ sơ`
  String get profile {
    return Intl.message(
      'Hồ sơ',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Cài đặt`
  String get settings {
    return Intl.message(
      'Cài đặt',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Tìm kiếm khóa học`
  String get search_course {
    return Intl.message(
      'Tìm kiếm khóa học',
      name: 'search_course',
      desc: '',
      args: [],
    );
  }

  /// `Đề bài`
  String get problem_tab {
    return Intl.message(
      'Đề bài',
      name: 'problem_tab',
      desc: '',
      args: [],
    );
  }

  /// `Bài làm`
  String get code_tab {
    return Intl.message(
      'Bài làm',
      name: 'code_tab',
      desc: '',
      args: [],
    );
  }

  /// `Kết quả chấm bài`
  String get problem_result {
    return Intl.message(
      'Kết quả chấm bài',
      name: 'problem_result',
      desc: '',
      args: [],
    );
  }

  /// `Tổng điểm`
  String get total_point {
    return Intl.message(
      'Tổng điểm',
      name: 'total_point',
      desc: '',
      args: [],
    );
  }

  /// `Lịch sử chấm bài`
  String get problem_history {
    return Intl.message(
      'Lịch sử chấm bài',
      name: 'problem_history',
      desc: '',
      args: [],
    );
  }

  /// `Bảng xếp hạng`
  String get ranking {
    return Intl.message(
      'Bảng xếp hạng',
      name: 'ranking',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật`
  String get update {
    return Intl.message(
      'Cập nhật',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Đổi mật khẩu`
  String get change_password {
    return Intl.message(
      'Đổi mật khẩu',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Phiên đăng nhập đã hết hạn`
  String get session_expired {
    return Intl.message(
      'Phiên đăng nhập đã hết hạn',
      name: 'session_expired',
      desc: '',
      args: [],
    );
  }

  /// `Có lỗi xảy ra`
  String get have_error {
    return Intl.message(
      'Có lỗi xảy ra',
      name: 'have_error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
