import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    final bool me = GoRouterState.of(context).queryParams['me'] == 'true';
    if (location.startsWith('/courses')) {
      return me ? 1 : 0;
    }

    if (location.startsWith('/profile')) {
      return 2;
    }

    return 0;
  }
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: ScaffoldWithNavBar._calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRoute.courses.name);
        break;
      case 1:
        context.goNamed(AppRoute.courses.name, queryParams: {'me': 'true'});
        break;
      case 2:
        context.goNamed(AppRoute.profile.name);
        break;
      // case 3:
      //   context.goNamed(AppRoute.settings.name);
      //   break;
    }
  }
}
