import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/configs/app_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/go_router_refresh_stream.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/screens/auth/login_screen.dart';
import 'package:code_space_client/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Di.init();
  await AppConfigManager.init(environmentType: EnvironmentType.dev);

  // Remove the hash from the URL
  setPathUrlStrategy();

  runApp(
    BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>()..checkAuth(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Have to put the GoRouter inside build to make refreshListenable work
    // I don't know why...
    // TODO: Figure out why :)
    final AuthCubit authCubit = context.read<AuthCubit>();
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
      ],
      initialLocation: '/login',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final loggedIn = context.read<AuthCubit>().state.authStatus ==
            AuthStatus.authenticated;

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
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
    );

    return MaterialApp.router(
      title: 'Code Space',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
