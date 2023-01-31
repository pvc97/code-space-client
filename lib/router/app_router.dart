import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/auth/sign_up_screen.dart';
import 'package:code_space_client/presentation/course_list/course_list_screen.dart';
import 'package:code_space_client/router/go_router_refresh_stream.dart';
import 'package:code_space_client/presentation/auth/login_screen.dart';
import 'package:code_space_client/presentation/home/home_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  login,
  signUp,
  courseList,
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
            name: AppRoute.courseList.name,
            builder: (context, state) {
              return const CourseListScreen();
            },
          ),
        ]),
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
