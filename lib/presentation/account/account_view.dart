import 'package:code_space_client/blocs/account/account_cubit.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/utils/extensions/role_type_ext.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _scrollController.jumpTo(0);
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
    return MultiBlocListener(
      listeners: [
        const BlocListener<AccountCubit, AccountState>(
          listener: stateStatusListener,
        ),
        BlocListener<AccountCubit, AccountState>(
          listenWhen: (previous, current) => previous.query != current.query,
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
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.s24,
                          vertical: Sizes.s12,
                        ),
                        leading: Image.asset(account.roleType.imagePath),
                        title: Text(
                          account.name,
                          style: AppTextStyle.defaultFont.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${account.userName}\n${account.email}',
                          style: AppTextStyle.defaultFont,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
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
