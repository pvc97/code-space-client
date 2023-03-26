import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/enums/problem_action.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/common_widgets/app_popup_menu_button.dart';
import 'package:code_space_client/presentation/common_widgets/show_confirm_dialog.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';

class ProblemItemWidget extends StatelessWidget {
  final ProblemModel problem;
  final UserModel? user;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const ProblemItemWidget({
    Key? key,
    required this.problem,
    this.user,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        left: Sizes.s24,
        right: Sizes.s24,
        bottom: Sizes.s8,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(Sizes.s24),
        title: Text(problem.name),
        trailing: (user.isTeacher)
            ? AppPopupMenuButton(
                items: ProblemAction.values
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
                    case ProblemAction.edit:
                      onUpdate();
                      break;
                    case ProblemAction.delete:
                      showConfirmDialog(
                        ctx: context,
                        title: S.of(context).delete_problem,
                        content: S.of(context).confirm_delete_problem,
                        onConfirm: onDelete,
                      );
                      break;
                  }
                },
              )
            : (user.isStudent && problem.completed)
                ? const Icon(
                    Bootstrap.check2_circle,
                    color: AppColor.primaryColor,
                  )
                : null,
      ),
    );
  }
}
