import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/user/user_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.goNamed(AppRoute.courseList.name);
                },
                child: Text(S.of(context).course_list),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text(S.of(context).my_courses),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text(S.of(context).profile),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text(S.of(context).settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
