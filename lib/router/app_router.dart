import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/account/account_screen.dart';
import 'package:code_space_client/presentation/auth/sign_up_screen.dart';
import 'package:code_space_client/presentation/change_password/change_password_screen.dart';
import 'package:code_space_client/presentation/course_detail/course_detail_screen.dart';
import 'package:code_space_client/presentation/course_list/course_list_screen.dart';
import 'package:code_space_client/presentation/create_account/create_account_screen.dart';
import 'package:code_space_client/presentation/create_course/create_course_screen.dart';
import 'package:code_space_client/presentation/create_problem/create_problem_screen.dart';
import 'package:code_space_client/presentation/common_widgets/scaffold_with_nav_bar.dart';
import 'package:code_space_client/presentation/problem/problem_screen.dart';
import 'package:code_space_client/presentation/problem_history/problem_history_screen.dart';
import 'package:code_space_client/presentation/problem_result/problem_result_screen.dart';
import 'package:code_space_client/presentation/profile/profile_screen.dart';
import 'package:code_space_client/presentation/ranking/ranking_screen.dart';
import 'package:code_space_client/presentation/reset_password/reset_password_screen.dart';
import 'package:code_space_client/presentation/setting/setting_screen.dart';
import 'package:code_space_client/presentation/update_account/update_account_screen.dart';
import 'package:code_space_client/presentation/update_course/update_course_screen.dart';
import 'package:code_space_client/presentation/update_problem/update_problem_screen.dart';
import 'package:code_space_client/router/adaptive_transition_page.dart';
import 'package:code_space_client/router/go_router_refresh_stream.dart';
import 'package:code_space_client/presentation/auth/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  login,
  signUp,
  courses,
  problem,
  ranking,
  profile,
  account,
  settings,
  courseDetail,
  createCourse,
  createAccount,
  problemResult,
  createProblem,
  resetPassword,
  problemHistory,
  changePassword,
  updateAccount,
  updateCourse,
  updateProblem,
}

// NOTE: All screen wrap by ShellRoute don't need to use bottom navigation bar
// have to use _rootNavigatorKey
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      pageBuilder: (context, state) {
        return AdaptiveTransitionPage.create(
          state.pageKey,
          child: const LoginScreen(),
        );
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/courses',
          name: AppRoute.courses.name,
          pageBuilder: (context, state) {
            final me = state.queryParams['me'] == 'true';
            return NoTransitionPage(
              key: state.pageKey,
              child: CourseListScreen(
                me: me,
                key: ValueKey(me),
                // Add key to force rebuild when me changes
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'create',
              name: AppRoute.createCourse.name,
              parentNavigatorKey:
                  _rootNavigatorKey, // Open new screen without bottom nav bar
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: const CreateCourseScreen(),
                );
              },
            ),
            GoRoute(
              path: 'update/:courseId',
              name: AppRoute.updateCourse.name,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: UpdateCourseScreen(
                    courseId: state.params['courseId'] ?? '',
                  ),
                );
              },
            ),
            GoRoute(
              path: ':courseId',
              name: AppRoute.courseDetail.name,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: CourseDetailScreen(
                    courseId: state.params['courseId'] ?? '',
                    me: state.queryParams['me'] == 'true',
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: 'create',
                  name: AppRoute.createProblem.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    return AdaptiveTransitionPage.create(
                      state.pageKey,
                      child: CreateProblemScreen(
                        courseId: state.params['courseId'] ?? '',
                        me: state.queryParams['me'] == 'true',
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'update/:problemId',
                  name: AppRoute.updateProblem.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    return AdaptiveTransitionPage.create(
                      state.pageKey,
                      child: UpdateProblemScreen(
                        problemId: state.params['problemId'] ?? '',
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'problem/:problemId',
                  name: AppRoute.problem.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    return AdaptiveTransitionPage.create(
                      state.pageKey,
                      child: ProblemScreen(
                        problemId: state.params['problemId'] ?? '',
                        courseId: state.params['courseId'] ?? '',
                        me: state.queryParams['me'] == 'true',
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'submit/:submitId',
                      name: AppRoute.problemResult.name,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        return AdaptiveTransitionPage.create(
                          state.pageKey,
                          child: ProblemResultScreen(
                              submitId: state.params['submitId'] ?? ''),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'history',
                      name: AppRoute.problemHistory.name,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        return AdaptiveTransitionPage.create(
                          state.pageKey,
                          child: ProblemHistoryScreen(
                            problemId: state.params['problemId'] ?? '',
                            courseId: state.params['courseId'] ?? '',
                            me: state.queryParams['me'] == 'true',
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'ranking',
                  name: AppRoute.ranking.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    return AdaptiveTransitionPage.create(
                      state.pageKey,
                      child: RankingScreen(
                        courseId: state.params['courseId'] ?? '',
                        me: state.queryParams['me'] == 'true',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          name: AppRoute.profile.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            );
          },
          routes: [
            GoRoute(
              path: 'setting',
              name: AppRoute.settings.name,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: const SettingScreen(),
                );
              },
            ),
            GoRoute(
              path: 'change-password',
              name: AppRoute.changePassword.name,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: const ChangePasswordScreen(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/account',
          name: AppRoute.account.name,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const AccountScreen(),
            );
          },
          routes: [
            GoRoute(
              path: 'create',
              name: AppRoute.createAccount.name,
              parentNavigatorKey:
                  _rootNavigatorKey, // Open new screen without bottom nav bar
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: const CreateAccountScreen(),
                );
              },
            ),
            GoRoute(
              path: 'reset-password/:userId',
              name: AppRoute.resetPassword.name,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: ResetPasswordScreen(
                    userId: state.params['userId'] ?? '',
                  ),
                );
              },
            ),
            GoRoute(
              path: 'update/:userId',
              name: AppRoute.updateAccount.name,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (context, state) {
                return AdaptiveTransitionPage.create(
                  state.pageKey,
                  child: UpdateAccountScreen(
                    userId: state.params['userId'] ?? '',
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/sign-up',
      name: AppRoute.signUp.name,
      pageBuilder: (context, state) {
        return AdaptiveTransitionPage.create(
          state.pageKey,
          child: const SignUpScreen(),
        );
      },
    ),
  ],
  initialLocation: '/login',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final loggedIn =
        context.read<AuthCubit>().state.authStatus == AuthStatus.authenticated;

    final subloc = state.subloc;

    // subloc vs location
    // subloc: /courses
    // location: /courses?me=true
    // => Use subloc

    if (subloc == '/login' || subloc == '/sign-up') {
      if (loggedIn) {
        // Because /courses is the screen that is shown when the user is logged in
        return '/courses';
      } else {
        return null;
      }
    } else {
      if (!loggedIn && subloc != '/sign-up') {
        return '/login';
      }
    }

    return null;
  },
  refreshListenable: GoRouterRefreshStream(
    stream: sl<AuthCubit>().stream,
    equals: (oldState, newState) => oldState.authStatus == newState.authStatus,
    // Because AuthState have multiple fields,
    // I only want to refresh when authStatus changes
    // If equals returns true, new event will not be emitted
    // => Prevent duplicate refresh
  ),
);
