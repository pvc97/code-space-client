import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/user/user_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
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
      appBar: AdaptiveAppBar(
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
        child: Box(
          width: Sizes.s300,
          child: ListView(
            shrinkWrap: true,
            children: [
              AppElevatedButton(
                onPressed: () => context.goNamed(AppRoute.courses.name),
                text: S.of(context).course_list,
              ),
              Box.h12,
              AppElevatedButton(
                onPressed: () {
                  context.goNamed(AppRoute.courses.name, queryParams: {
                    'me': 'true',
                  });
                },
                text: S.of(context).my_courses,
              ),
              Box.h12,
              AppElevatedButton(
                onPressed: () {
                  context.goNamed(AppRoute.profile.name);
                },
                text: S.of(context).profile,
              ),
              Box.h12,
              AppElevatedButton(
                onPressed: () {},
                text: S.of(context).settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
