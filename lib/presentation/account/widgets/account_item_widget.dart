import 'package:code_space_client/blocs/account/account_cubit.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/enums/account_action.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/presentation/common_widgets/app_popup_menu_button.dart';
import 'package:code_space_client/presentation/common_widgets/show_confirm_dialog.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/role_type_ext.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountItemWidget extends StatelessWidget {
  final UserModel account;

  const AccountItemWidget({
    Key? key,
    required this.account,
  }) : super(key: key);

  void _deleteAccount(BuildContext ctx) {
    final accountCubit = ctx.read<AccountCubit>();
    accountCubit.deleteAccount(userId: account.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
        // Manager can't edit, reset password or delete other managers
        trailing: account.roleType == RoleType.manager
            ? null
            : AppPopupMenuButton(
                items: AccountAction.values
                    .map(
                      (action) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        value: action,
                        child: ListTile(
                          leading: action.icon,
                          title: Text(
                            action.getName(context),
                            style: AppTextStyle.defaultFont,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  switch (value) {
                    case AccountAction.edit:
                      logger.d('Edit account');
                      break;
                    case AccountAction.resetPassword:
                      context.goNamed(
                        AppRoute.resetPassword.name,
                        params: {'userId': account.userId},
                      );
                      break;
                    case AccountAction.delete:
                      showConfirmDialog(
                        ctx: context,
                        title: S.of(context).delete_account,
                        content: S.of(context).confirm_delete_account,
                        onConfirm: () {
                          _deleteAccount(context);
                        },
                      );
                      break;
                  }
                },
              ),
      ),
    );
  }
}
