import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/configs/app_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/cubits/locale/locale_cubit.dart';
import 'package:code_space_client/cubits/user/user_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Di.init();
  await AppConfigManager.init(environmentType: EnvironmentType.dev);

  // https://github.com/flutter/flutter/issues/107996
  usePathUrlStrategy();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<UserCubit>()),
        // I think UserCubit should be here to be able access it from any screen
        // because a lot of screens need to access user info
        BlocProvider(create: (_) => sl<LocaleCubit>()),
      ],
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
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Code Space',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          debugShowCheckedModeBanner: false,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: state.locale,
          supportedLocales: S.delegate.supportedLocales,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
