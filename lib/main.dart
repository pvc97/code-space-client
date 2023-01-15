import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/configs/app_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Di.init();
  await AppConfigManager.init(environmentType: EnvironmentType.dev);

  // Remove the hash from the URL
  setPathUrlStrategy();

  runApp(
    BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
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
