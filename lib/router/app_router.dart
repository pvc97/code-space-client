import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/router/go_router_refresh_stream.dart';
import 'package:code_space_client/screens/auth/login_screen.dart';
import 'package:code_space_client/screens/home/home_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  login,
  home,
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
