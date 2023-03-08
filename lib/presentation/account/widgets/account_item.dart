import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/models/enums/account_action.dart';
import 'package:code_space_client/presentation/common_widgets/app_popup_menu_button.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/role_type_ext.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:go_router/go_router.dart';

class AccountItem extends StatelessWidget {
  final UserModel account;

  const AccountItem({
    Key? key,
    required this.account,
  }) : super(key: key);

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
        // trailing: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.more_vert),
        // ),
        trailing: AppPopupMenuButton(
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
                logger.d('Delete account');
                break;
            }
          },
        ),
      ),
    );
  }
}
