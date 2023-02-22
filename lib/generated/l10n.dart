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

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_an_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message(
      'Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message(
      'Full name',
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

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get password_cannot_be_empty {
    return Intl.message(
      'Password cannot be empty',
      name: 'password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get username_cannot_be_empty {
    return Intl.message(
      'Username cannot be empty',
      name: 'username_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `No network`
  String get no_network {
    return Intl.message(
      'No network',
      name: 'no_network',
      desc: '',
      args: [],
    );
  }

  /// `Full name cannot be empty`
  String get full_name_cannot_be_empty {
    return Intl.message(
      'Full name cannot be empty',
      name: 'full_name_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get email_cannot_be_empty {
    return Intl.message(
      'Email cannot be empty',
      name: 'email_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Course List`
  String get course_list {
    return Intl.message(
      'Course List',
      name: 'course_list',
      desc: '',
      args: [],
    );
  }

  /// `My Courses`
  String get my_courses {
    return Intl.message(
      'My Courses',
      name: 'my_courses',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Search course`
  String get search_course {
    return Intl.message(
      'Search course',
      name: 'search_course',
      desc: '',
      args: [],
    );
  }

  /// `Problem`
  String get problem_tab {
    return Intl.message(
      'Problem',
      name: 'problem_tab',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code_tab {
    return Intl.message(
      'Code',
      name: 'code_tab',
      desc: '',
      args: [],
    );
  }

  /// `Problem result`
  String get problem_result {
    return Intl.message(
      'Problem result',
      name: 'problem_result',
      desc: '',
      args: [],
    );
  }

  /// `Total point`
  String get total_point {
    return Intl.message(
      'Total point',
      name: 'total_point',
      desc: '',
      args: [],
    );
  }

  /// `Submission history`
  String get problem_history {
    return Intl.message(
      'Submission history',
      name: 'problem_history',
      desc: '',
      args: [],
    );
  }

  /// `Ranking`
  String get ranking {
    return Intl.message(
      'Ranking',
      name: 'ranking',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Session expired`
  String get session_expired {
    return Intl.message(
      'Session expired',
      name: 'session_expired',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get an_error_occurred {
    return Intl.message(
      'An error occurred',
      name: 'an_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get comment_login____ {
    return Intl.message(
      '',
      name: 'comment_login____',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_screen_title {
    return Intl.message(
      'Login',
      name: 'login_screen_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get comment_home____ {
    return Intl.message(
      '',
      name: 'comment_home____',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home_screen_title {
    return Intl.message(
      'Home',
      name: 'home_screen_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get comment_role____ {
    return Intl.message(
      '',
      name: 'comment_role____',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get role_student {
    return Intl.message(
      'Student',
      name: 'role_student',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get role_teacher {
    return Intl.message(
      'Teacher',
      name: 'role_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Manager`
  String get role_manager {
    return Intl.message(
      'Manager',
      name: 'role_manager',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Search problem`
  String get search_problem {
    return Intl.message(
      'Search problem',
      name: 'search_problem',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Course code`
  String get course_code {
    return Intl.message(
      'Course code',
      name: 'course_code',
      desc: '',
      args: [],
    );
  }

  /// `Access code`
  String get access_code {
    return Intl.message(
      'Access code',
      name: 'access_code',
      desc: '',
      args: [],
    );
  }

  /// `Join now`
  String get join_now {
    return Intl.message(
      'Join now',
      name: 'join_now',
      desc: '',
      args: [],
    );
  }

  /// `Enter access code`
  String get enter_access_code {
    return Intl.message(
      'Enter access code',
      name: 'enter_access_code',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel {
    return Intl.message(
      'CANCEL',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Create new course`
  String get create_new_course {
    return Intl.message(
      'Create new course',
      name: 'create_new_course',
      desc: '',
      args: [],
    );
  }

  /// `Course name`
  String get course_name {
    return Intl.message(
      'Course name',
      name: 'course_name',
      desc: '',
      args: [],
    );
  }

  /// `Course name cannot be empty`
  String get course_name_cannot_be_empty {
    return Intl.message(
      'Course name cannot be empty',
      name: 'course_name_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Course code cannot be empty`
  String get course_code_cannot_be_empty {
    return Intl.message(
      'Course code cannot be empty',
      name: 'course_code_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Access code cannot be empty`
  String get access_code_cannot_be_empty {
    return Intl.message(
      'Access code cannot be empty',
      name: 'access_code_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Select teacher`
  String get select_teacher {
    return Intl.message(
      'Select teacher',
      name: 'select_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Enter name or email of teacher`
  String get enter_name_or_email_of_teacher {
    return Intl.message(
      'Enter name or email of teacher',
      name: 'enter_name_or_email_of_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Please select teacher`
  String get please_select_teacher {
    return Intl.message(
      'Please select teacher',
      name: 'please_select_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Course created successfully`
  String get course_created_successfully {
    return Intl.message(
      'Course created successfully',
      name: 'course_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `The course has no problems`
  String get the_course_has_no_problems {
    return Intl.message(
      'The course has no problems',
      name: 'the_course_has_no_problems',
      desc: '',
      args: [],
    );
  }

  /// `Create new problem`
  String get create_new_problem {
    return Intl.message(
      'Create new problem',
      name: 'create_new_problem',
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
