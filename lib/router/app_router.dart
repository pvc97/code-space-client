import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/auth/sign_up_screen.dart';
import 'package:code_space_client/presentation/course_detail/course_detail.dart';
import 'package:code_space_client/presentation/course_list/course_list_screen.dart';
import 'package:code_space_client/presentation/problem/problem_screen.dart';
import 'package:code_space_client/presentation/problem_history/problem_history_screen.dart';
import 'package:code_space_client/presentation/problem_result/problem_result_screen.dart';
import 'package:code_space_client/presentation/ranking/ranking_screen.dart';
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
  courseDetail,
  problemResult,
  problemHistory,
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: 'courses',
          name: AppRoute.courses.name,
          builder: (context, state) {
            final me = state.queryParams['me'] == 'true';
            return CourseListScreen(me: me);
          },
          routes: [
            GoRoute(
              path: ':courseId',
              name: AppRoute.courseDetail.name,
              builder: (context, state) {
                final me = state.queryParams['me'] == 'true';
                return CourseDetailScreen(
                  courseId: state.params['courseId'] ?? '',
                  me: me,
                );
              },
              routes: [
                GoRoute(
                  path: 'problem/:problemId',
                  name: AppRoute.problem.name,
                  builder: (context, state) {
                    final problemId = state.params['problemId'] ?? '';
                    final courseId = state.params['courseId'] ?? '';
                    final me = state.queryParams['me'] == 'true';
                    return ProblemScreen(
                      problemId: problemId,
                      courseId: courseId,
                      me: me,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'submit/:submitId',
                      name: AppRoute.problemResult.name,
                      builder: (context, state) {
                        final submitId = state.params['submitId'] ?? '';
                        return ProblemResultScreen(submitId: submitId);
                      },
                    ),
                    GoRoute(
                      path: 'history',
                      name: AppRoute.problemHistory.name,
                      builder: (context, state) {
                        final problemId = state.params['problemId'] ?? '';
                        final courseId = state.params['courseId'] ?? '';
                        final me = state.queryParams['me'] == 'true';
                        return ProblemHistoryScreen(
                          problemId: problemId,
                          courseId: courseId,
                          me: me,
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'ranking',
                  name: AppRoute.ranking.name,
                  builder: (context, state) {
                    final courseId = state.params['courseId'] ?? '';
                    final me = state.queryParams['me'] == 'true';
                    return RankingScreen(
                      courseId: courseId,
                      me: me,
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
      builder: (context, state) {
        return const SignUpScreen();
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
    } else if (subloc == '/') {
      if (!loggedIn) {
        return '/login';
      }
    }

    return null;
  },
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
);
