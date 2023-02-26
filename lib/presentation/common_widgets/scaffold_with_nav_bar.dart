import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

// Follow example from:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/shell_route.dart
class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);
    return Scaffold(
      body: widget.child,
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: const Icon(Bootstrap.book_half),
      //       label: S.of(context).courses,
      //     ),
      //     (user?.roleType != RoleType.manager)
      //         ? BottomNavigationBarItem(
      //             icon: const Icon(Bootstrap.bookmark_heart),
      //             label: S.of(context).my_courses,
      //           )
      //         : BottomNavigationBarItem(
      //             icon: const Icon(Bootstrap.people),
      //             label: S.of(context).accounts,
      //           ),
      //     BottomNavigationBarItem(
      //       icon: const Icon(Bootstrap.person),
      //       label: S.of(context).profile,
      //     ),
      //   ],
      //   currentIndex: _calculateSelectedIndex(context),
      //   onTap: (int idx) => _onItemTapped(idx, context, user?.roleType),
      // ),
      bottomNavigationBar: NavigationBar(
        height: Sizes.s56,
        elevation: Sizes.s8,
        backgroundColor: Colors.white,
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int idx) =>
            _onItemTapped(idx, context, user?.roleType),
        destinations: [
          NavigationDestination(
            icon: const Icon(Bootstrap.book_half),
            label: S.of(context).courses,
          ),
          (user?.roleType != RoleType.manager)
              ? NavigationDestination(
                  icon: const Icon(Bootstrap.bookmark_heart),
                  label: S.of(context).my_courses,
                )
              : NavigationDestination(
                  icon: const Icon(Bootstrap.people),
                  label: S.of(context).accounts,
                ),
          NavigationDestination(
            icon: const Icon(Bootstrap.person),
            label: S.of(context).profile,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context, RoleType? role) {
    switch (index) {
      case 0:
        context.goNamed(AppRoute.courses.name);
        break;
      case 1:
        if (role == RoleType.manager) {
          context.goNamed(AppRoute.account.name);
        } else {
          context.goNamed(AppRoute.courses.name, queryParams: {'me': 'true'});
        }
        break;
      case 2:
        context.goNamed(AppRoute.profile.name);
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    final bool me = GoRouterState.of(context).queryParams['me'] == 'true';

    if (location.startsWith('/account')) {
      return 1;
    }

    if (location.startsWith('/courses')) {
      return me ? 1 : 0;
    }

    if (location.startsWith('/profile')) {
      return 2;
    }

    return 0;
  }
}
