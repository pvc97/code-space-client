import 'package:code_space_client/blocs/account/account_cubit.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/account/widgets/account_item_widget.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/empty_widget.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';
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
            stateStatusListener(
              context,
              state,
              stateStatus: state.deleteStatus,
              onSuccess: () {
                EasyLoading.showSuccess(
                  S.of(context).delete_account_success,
                  dismissOnTap: true,
                );
              },
            );
          },
        ),
        BlocListener<AccountCubit, AccountState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        BlocListener<AccountCubit, AccountState>(
          listenWhen: (previous, current) {
            return previous.query != current.query;
          },
          listener: (context, state) {
            _resetScrollPosition();
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          showHomeButton: false,
          title: Container(
            margin: const EdgeInsets.only(left: Sizes.s20),
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
            if (user.isManager)
              IconButton(
                onPressed: () {
                  context.goNamed(AppRoute.createAccount.name);
                },
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _refreshAccounts();
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              BlocBuilder<AccountCubit, AccountState>(
                buildWhen: (previous, current) =>
                    previous.accounts != current.accounts,
                builder: (context, state) {
                  final accounts = state.accounts;

                  if (state.stateStatus == StateStatus.initial) {
                    return const SliverToBoxAdapter();
                  }

                  if (accounts.isEmpty) {
                    String message;
                    if (state.query.trim().isEmpty) {
                      message = S.of(context).no_accounts_have_been_created_yet;
                    } else {
                      message = S.of(context).account_not_found;
                    }

                    return SliverFillRemaining(
                      child: Center(
                        child: EmptyWidget(message: message),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.s12,
                      horizontal: Sizes.s20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: accounts.length + 1,
                        (context, index) {
                          if (index == accounts.length) {
                            // Check stateStatus to avoid infinite loop call loadMore
                            if (state.isLoadMoreDone ||
                                state.stateStatus != StateStatus.success) {
                              return Box.shrink;
                            }

                            // Loadmore when last item is rendered
                            _loadMore();

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final account = accounts[index];
                          return AccountItemWidget(
                            account: account,
                            key: ValueKey(account.userId),
                            onDelete: () {
                              context
                                  .read<AccountCubit>()
                                  .deleteAccount(userId: account.userId);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
