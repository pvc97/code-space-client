import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';
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
    context.read<UserCubit>().getMe();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth <= AppConstants.maxMobileWidth;
      return Scaffold(
        body: isMobile
            ? widget.child
            : Row(
                children: [
                  NavigationRail(
                    // https://github.com/flutter/flutter/issues/117126
                    // From this issue, flutter team said it fixed, but it's not
                    elevation: Sizes.s4,
                    backgroundColor: AppColor.primaryColor.shade50,
                    selectedIndex: _calculateSelectedIndex(context),
                    labelType: NavigationRailLabelType.all,
                    minWidth: Sizes
                        .s112, // To fix above issue, I have to set minWidth
                    onDestinationSelected: (int idx) =>
                        _onItemTapped(idx, context, user?.roleType),
                    trailing: Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: IconButton(
                            onPressed: () {
                              context.read<AuthCubit>().logout();
                            },
                            icon: const Icon(Bootstrap.box_arrow_left),
                          ),
                        ),
                      ),
                    ),
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(
                          Bootstrap.book,
                          color: AppColor.primaryColor,
                        ),
                        selectedIcon: const Icon(
                          Bootstrap.book_half,
                          color: AppColor.selectedNavIconColor,
                        ),
                        label: Text(S.of(context).courses),
                      ),
                      (!user.isManager)
                          ? NavigationRailDestination(
                              icon: const Icon(
                                Bootstrap.bookmark_heart,
                                color: AppColor.primaryColor,
                              ),
                              selectedIcon: const Icon(
                                Bootstrap.bookmark_heart_fill,
                                color: AppColor.selectedNavIconColor,
                              ),
                              label: Text(S.of(context).my_courses),
                            )
                          : NavigationRailDestination(
                              icon: const Icon(
                                Bootstrap.people,
                                color: AppColor.primaryColor,
                              ),
                              selectedIcon: const Icon(
                                Bootstrap.people_fill,
                                color: AppColor.selectedNavIconColor,
                              ),
                              label: Text(S.of(context).accounts),
                            ),
                      NavigationRailDestination(
                        label: Text(S.of(context).profile),
                        icon: const Icon(
                          Bootstrap.person,
                          color: AppColor.primaryColor,
                        ),
                        selectedIcon: const Icon(
                          Bootstrap.person_fill,
                          color: AppColor.selectedNavIconColor,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: widget.child),
                ],
              ),
        bottomNavigationBar: !isMobile
            ? null
            : NavigationBar(
                height: Sizes.s56,
                elevation: Sizes.s4,
                selectedIndex: _calculateSelectedIndex(context),
                onDestinationSelected: (int idx) =>
                    _onItemTapped(idx, context, user?.roleType),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(
                      Bootstrap.book,
                      color: AppColor.primaryColor,
                    ),
                    selectedIcon: const Icon(
                      Bootstrap.book_half,
                      color: AppColor.selectedNavIconColor,
                    ),
                    label: S.of(context).courses,
                  ),
                  (!user.isManager)
                      ? NavigationDestination(
                          icon: const Icon(
                            Bootstrap.bookmark_heart,
                            color: AppColor.primaryColor,
                          ),
                          selectedIcon: const Icon(
                            Bootstrap.bookmark_heart_fill,
                            color: AppColor.selectedNavIconColor,
                          ),
                          label: S.of(context).my_courses,
                        )
                      : NavigationDestination(
                          icon: const Icon(
                            Bootstrap.people,
                            color: AppColor.primaryColor,
                          ),
                          selectedIcon: const Icon(
                            Bootstrap.people_fill,
                            color: AppColor.selectedNavIconColor,
                          ),
                          label: S.of(context).accounts,
                        ),
                  NavigationDestination(
                    icon: const Icon(
                      Bootstrap.person,
                      color: AppColor.primaryColor,
                    ),
                    selectedIcon: const Icon(
                      Bootstrap.person_fill,
                      color: AppColor.selectedNavIconColor,
                    ),
                    label: S.of(context).profile,
                  ),
                ],
              ),
      );
    });
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
