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
  String get password_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'password_do_not_match',
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

  /// `Search course...`
  String get search_course {
    return Intl.message(
      'Search course...',
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

  /// `Search problem...`
  String get search_problem {
    return Intl.message(
      'Search problem...',
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

  /// `No problems found`
  String get no_problems_found {
    return Intl.message(
      'No problems found',
      name: 'no_problems_found',
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

  /// `Select languages`
  String get select_languages {
    return Intl.message(
      'Select languages',
      name: 'select_languages',
      desc: '',
      args: [],
    );
  }

  /// `Enter name of language`
  String get enter_name_of_language {
    return Intl.message(
      'Enter name of language',
      name: 'enter_name_of_language',
      desc: '',
      args: [],
    );
  }

  /// `Please select language`
  String get please_select_language {
    return Intl.message(
      'Please select language',
      name: 'please_select_language',
      desc: '',
      args: [],
    );
  }

  /// `Problem name`
  String get problem_name {
    return Intl.message(
      'Problem name',
      name: 'problem_name',
      desc: '',
      args: [],
    );
  }

  /// `Problem name cannot be empty`
  String get problem_name_cannot_be_empty {
    return Intl.message(
      'Problem name cannot be empty',
      name: 'problem_name_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Point per test case`
  String get point_per_test_case {
    return Intl.message(
      'Point per test case',
      name: 'point_per_test_case',
      desc: '',
      args: [],
    );
  }

  /// `Invalid point per test case`
  String get invalid_point_per_test_case {
    return Intl.message(
      'Invalid point per test case',
      name: 'invalid_point_per_test_case',
      desc: '',
      args: [],
    );
  }

  /// `List of test cases:`
  String get list_of_test_cases {
    return Intl.message(
      'List of test cases:',
      name: 'list_of_test_cases',
      desc: '',
      args: [],
    );
  }

  /// `Add new`
  String get add_test_case {
    return Intl.message(
      'Add new',
      name: 'add_test_case',
      desc: '',
      args: [],
    );
  }

  /// `Select problem file:`
  String get select_problem_file {
    return Intl.message(
      'Select problem file:',
      name: 'select_problem_file',
      desc: '',
      args: [],
    );
  }

  /// `Test case`
  String get test_case {
    return Intl.message(
      'Test case',
      name: 'test_case',
      desc: '',
      args: [],
    );
  }

  /// `Stdin:`
  String get stdin {
    return Intl.message(
      'Stdin:',
      name: 'stdin',
      desc: '',
      args: [],
    );
  }

  /// `Expected output:`
  String get expected_output {
    return Intl.message(
      'Expected output:',
      name: 'expected_output',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get please_fill_all_fields {
    return Intl.message(
      'Please fill all fields',
      name: 'please_fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Course`
  String get course {
    return Intl.message(
      'Course',
      name: 'course',
      desc: '',
      args: [],
    );
  }

  /// `User list`
  String get user_list {
    return Intl.message(
      'User list',
      name: 'user_list',
      desc: '',
      args: [],
    );
  }

  /// `Show when wrong:`
  String get show_when_wrong {
    return Intl.message(
      'Show when wrong:',
      name: 'show_when_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message(
      'Courses',
      name: 'courses',
      desc: '',
      args: [],
    );
  }

  /// `Leave course`
  String get leave_course {
    return Intl.message(
      'Leave course',
      name: 'leave_course',
      desc: '',
      args: [],
    );
  }

  /// `Confirm leave course?`
  String get confirm_leave_course {
    return Intl.message(
      'Confirm leave course?',
      name: 'confirm_leave_course',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Username only alphanumeric`
  String get username_only_alphanumeric {
    return Intl.message(
      'Username only alphanumeric',
      name: 'username_only_alphanumeric',
      desc: '',
      args: [],
    );
  }

  /// `Email is not valid`
  String get email_is_not_valid {
    return Intl.message(
      'Email is not valid',
      name: 'email_is_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `Search accounts...`
  String get search_accounts {
    return Intl.message(
      'Search accounts...',
      name: 'search_accounts',
      desc: '',
      args: [],
    );
  }

  /// `Create new account`
  String get create_new_account {
    return Intl.message(
      'Create new account',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `Please select role`
  String get please_select_role {
    return Intl.message(
      'Please select role',
      name: 'please_select_role',
      desc: '',
      args: [],
    );
  }

  /// `Select role`
  String get select_role {
    return Intl.message(
      'Select role',
      name: 'select_role',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get create_account {
    return Intl.message(
      'Create account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully`
  String get account_created_successfully {
    return Intl.message(
      'Account created successfully',
      name: 'account_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Current password cannot be empty`
  String get current_password_cannot_be_empty {
    return Intl.message(
      'Current password cannot be empty',
      name: 'current_password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get current_password {
    return Intl.message(
      'Current password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `New password cannot be empty`
  String get new_password_cannot_be_empty {
    return Intl.message(
      'New password cannot be empty',
      name: 'new_password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm new password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `New password do not match`
  String get new_password_do_not_match {
    return Intl.message(
      'New password do not match',
      name: 'new_password_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Change password successfully`
  String get change_password_successfully {
    return Intl.message(
      'Change password successfully',
      name: 'change_password_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated`
  String get profile_updated {
    return Intl.message(
      'Profile updated',
      name: 'profile_updated',
      desc: '',
      args: [],
    );
  }

  /// `You are not the teacher of this course`
  String get you_are_not_the_teacher_of_this_course {
    return Intl.message(
      'You are not the teacher of this course',
      name: 'you_are_not_the_teacher_of_this_course',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get reset_password {
    return Intl.message(
      'Reset password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Reset password successfully`
  String get reset_password_successfully {
    return Intl.message(
      'Reset password successfully',
      name: 'reset_password_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this account?`
  String get confirm_delete_account {
    return Intl.message(
      'Are you sure you want to delete this account?',
      name: 'confirm_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Delete account success`
  String get delete_account_success {
    return Intl.message(
      'Delete account success',
      name: 'delete_account_success',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any course`
  String get you_don_t_have_any_course {
    return Intl.message(
      'You don\'t have any course',
      name: 'you_don_t_have_any_course',
      desc: '',
      args: [],
    );
  }

  /// `No courses have been created yet`
  String get no_courses_have_been_created_yet {
    return Intl.message(
      'No courses have been created yet',
      name: 'no_courses_have_been_created_yet',
      desc: '',
      args: [],
    );
  }

  /// `Course not found`
  String get course_not_found {
    return Intl.message(
      'Course not found',
      name: 'course_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Account not found`
  String get account_not_found {
    return Intl.message(
      'Account not found',
      name: 'account_not_found',
      desc: '',
      args: [],
    );
  }

  /// `No accounts have been created yet`
  String get no_accounts_have_been_created_yet {
    return Intl.message(
      'No accounts have been created yet',
      name: 'no_accounts_have_been_created_yet',
      desc: '',
      args: [],
    );
  }

  /// `No ranking yet`
  String get no_ranking_yet {
    return Intl.message(
      'No ranking yet',
      name: 'no_ranking_yet',
      desc: '',
      args: [],
    );
  }

  /// `Update account`
  String get update_account {
    return Intl.message(
      'Update account',
      name: 'update_account',
      desc: '',
      args: [],
    );
  }

  /// `Update account successfully`
  String get update_account_successfully {
    return Intl.message(
      'Update account successfully',
      name: 'update_account_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete course`
  String get delete_course {
    return Intl.message(
      'Delete course',
      name: 'delete_course',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this course?`
  String get confirm_delete_course {
    return Intl.message(
      'Are you sure you want to delete this course?',
      name: 'confirm_delete_course',
      desc: '',
      args: [],
    );
  }

  /// `Delete course success`
  String get delete_course_success {
    return Intl.message(
      'Delete course success',
      name: 'delete_course_success',
      desc: '',
      args: [],
    );
  }

  /// `Update course`
  String get update_course {
    return Intl.message(
      'Update course',
      name: 'update_course',
      desc: '',
      args: [],
    );
  }

  /// `Update course successfully`
  String get update_course_successfully {
    return Intl.message(
      'Update course successfully',
      name: 'update_course_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delete problem`
  String get delete_problem {
    return Intl.message(
      'Delete problem',
      name: 'delete_problem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this problem?`
  String get confirm_delete_problem {
    return Intl.message(
      'Are you sure you want to delete this problem?',
      name: 'confirm_delete_problem',
      desc: '',
      args: [],
    );
  }

  /// `Delete problem success`
  String get delete_problem_success {
    return Intl.message(
      'Delete problem success',
      name: 'delete_problem_success',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Actual output:`
  String get actual_output {
    return Intl.message(
      'Actual output:',
      name: 'actual_output',
      desc: '',
      args: [],
    );
  }

  /// `Update problem`
  String get update_problem {
    return Intl.message(
      'Update problem',
      name: 'update_problem',
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
