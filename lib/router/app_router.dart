import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/auth/sign_up_screen.dart';
import 'package:code_space_client/presentation/course_detail/course_detail.dart';
import 'package:code_space_client/presentation/course_list/course_list_screen.dart';
import 'package:code_space_client/presentation/problem/problem_screen.dart';
import 'package:code_space_client/presentation/problem_history/problem_history_screen.dart';
import 'package:code_space_client/presentation/problem_result/problem_result_screen.dart';
import 'package:code_space_client/presentation/profile/profile_screen.dart';
import 'package:code_space_client/presentation/ranking/ranking_screen.dart';
import 'package:code_space_client/router/adaptive_transition_page.dart';
import 'package:code_space_client/router/go_router_refresh_stream.dart';
import 'package:code_space_client/presentation/auth/login_screen.dart';
import 'package:code_space_client/presentation/home/home_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  login,
  signUp,
  courses,
  problem,
  ranking,
  profile,
  courseDetail,
  problemResult,
  problemHistory,
}

final GoRouter router = GoRouter(
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
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      pageBuilder: (context, state) {
        return AdaptiveTransitionPage.create(
          state.pageKey,
          child: const HomeScreen(),
        );
      },
      routes: [
        GoRoute(
          path: 'courses',
          name: AppRoute.courses.name,
          pageBuilder: (context, state) {
            final me = state.queryParams['me'] == 'true';
            return AdaptiveTransitionPage.create(
              state.pageKey,
              child: CourseListScreen(me: me),
            );
          },
          routes: [
            GoRoute(
              path: ':courseId',
              name: AppRoute.courseDetail.name,
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
                  path: 'problem/:problemId',
                  name: AppRoute.problem.name,
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
    GoRoute(
      path: '/profile',
      name: AppRoute.profile.name,
      pageBuilder: (context, state) {
        return AdaptiveTransitionPage.create(
          state.pageKey,
          child: const ProfileScreen(),
        );
      },
    ),
  ],
  initialLocation: '/login',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final loggedIn =
        sl<AuthCubit>().state.authStatus == AuthStatus.authenticated;

    final subloc = state.subloc;

    if (subloc == '/login') {
      if (loggedIn) {
        return '/';
      } else {
        return null;
      }
    } else {
      if (!loggedIn) {
        return '/login';
      }
    }

    return null;
  },
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
);
