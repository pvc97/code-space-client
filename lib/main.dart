import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/blocs/base/simple_bloc_observer.dart';
import 'package:code_space_client/configs/app_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/blocs/locale/locale_cubit.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//   _    _                                                        _   _
//  | |  | |                                                      | | (_)
//  | |__| |   __ _   _ __    _ __    _   _      ___    ___     __| |  _   _ __     __ _
//  |  __  |  / _` | | '_ \  | '_ \  | | | |    / __|  / _ \   / _` | | | | '_ \   / _` |
//  | |  | | | (_| | | |_) | | |_) | | |_| |   | (__  | (_) | | (_| | | | | | | | | (_| |
//  |_|  |_|  \__,_| | .__/  | .__/   \__, |    \___|  \___/   \__,_| |_| |_| |_|  \__, |
//                   | |     | |       __/ |                                        __/ |
//                   |_|     |_|      |___/                                        |___/

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = SimpleBlocObserver();
  }

  await Di.init();
  await AppConfigManager.init(
    environmentType: EnvironmentType.dev,
    binding: binding,
  );

  // https://github.com/flutter/flutter/issues/107996
  // TODO: Uncomment this line when the issue is fixed
  // usePathUrlStrategy();

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
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.unknown,
            },
            physics: const BouncingScrollPhysics(),
          ),
          title: 'Code Space',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: AppColor.primaryColor,
            appBarTheme: const AppBarTheme(
              color: AppColor.primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: AppColor.appBarTextColor,
                fontSize: Sizes.s20,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
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
