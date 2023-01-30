import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/user/user_cubit.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.user == null) {
              return const SizedBox.shrink();
            }
            logger.d(state.user!.name);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.user!.roleType.toString(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserCubit>().fetchUserInfo();
                  },
                  child: const Text('Fetch User from API'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
