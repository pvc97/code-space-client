import 'package:code_space_client/configs/app_config_manager.dart';
import 'package:code_space_client/configs/environment_type.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Di.init();
  await AppConfigManager.init(environmentType: EnvironmentType.dev);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
