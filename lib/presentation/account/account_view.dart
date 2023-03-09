import 'package:code_space_client/blocs/account/account_cubit.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/enums/delete_status.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/presentation/account/widgets/account_item_widget.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => AccountViewState();
}

class AccountViewState extends State<AccountView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountCubit>().getAccounts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScrollPosition() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _loadMore() {
    context.read<AccountCubit>().loadMoreAccounts();
  }

  void _refreshAccounts() {
    context.read<AccountCubit>().refreshAccounts();
  }

  void _searchAccount(String query) {
    context.read<AccountCubit>().searchAccounts(query: query);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);

    return MultiBlocListener(
      listeners: [
        BlocListener<AccountCubit, AccountState>(
          listenWhen: (previous, current) {
            return previous.deleteStatus != current.deleteStatus;
          },
          listener: (context, state) {
            // TODO: Extract this to a function
            final deleteStatus = state.deleteStatus;
            if (deleteStatus == DeleteStatus.deleting) {
              EasyLoading.show(dismissOnTap: true);
            } else if (deleteStatus == DeleteStatus.deleteSuccess) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess(S.of(context).delete_account_success);
            } else if (deleteStatus == DeleteStatus.deleteFailed) {
              EasyLoading.dismiss();
              if (state.error is NoNetworkException) {
                EasyLoading.showInfo(S.of(context).no_network,
                    dismissOnTap: true);
              } else {
                EasyLoading.showInfo(state.error?.message ?? '',
                    dismissOnTap: true);
              }
            }
          },
        ),
        BlocListener<AccountCubit, AccountState>(
            listenWhen: (previous, current) =>
                previous.stateStatus != current.stateStatus,
            listener: stateStatusListener),
        BlocListener<AccountCubit, AccountState>(
          listenWhen: (previous, current) {
            return previous.query != current.query;
          },
          listener: (context, state) {
            _resetScrollPosition();
          },
        ),
      ],
      child: Scaffold(
        appBar: AdaptiveAppBar(
          context: context,
          showHomeButton: false,
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
            child: TextField(
              decoration: InputDecoration(
                // border: InputBorder.none,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: S.of(context).search_accounts,
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                // Make textfield height smaller
                isDense: true,
                contentPadding: const EdgeInsets.all(Sizes.s8),
              ),
              onChanged: (value) {
                _searchAccount(value);
              },
            ),
          ),
          actions: [
            if (user?.roleType == RoleType.manager)
              IconButton(
                onPressed: () {
                  context.goNamed(AppRoute.createAccount.name);
                },
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: BlocBuilder<AccountCubit, AccountState>(
          buildWhen: (previous, current) =>
              previous.accounts != current.accounts,
          builder: (context, state) {
            final accounts = state.accounts;

            return RefreshIndicator(
              onRefresh: () async {
                _refreshAccounts();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.s12,
                  horizontal: Sizes.s20,
                ),
                itemCount: accounts.length + 1,
                itemBuilder: (context, index) {
                  if (index == accounts.length) {
                    // Check stateStatus to avoid infinite loop call loadMore
                    if (state.isLoadMoreDone ||
                        state.stateStatus != StateStatus.success) {
                      return const SizedBox.shrink();
                    }

                    // Loadmore when last item is rendered
                    _loadMore();

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final account = accounts[index];
                  return GestureDetector(
                    onTap: () {
                      // context.goNamed(
                      //   AppRoute.courseDetail.name,
                      //   params: {'courseId': course.id},
                      //   queryParams: widget.me ? {'me': 'true'} : {},
                      // );
                    },
                    child: AccountItemWidget(
                      account: account,
                      key: ValueKey(account.userId),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
