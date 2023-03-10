import 'package:flutter/material.dart';

import 'package:code_space_client/presentation/update_account/update_account_view.dart';

class UpdateAccountScreen extends StatelessWidget {
  final String userId;

  const UpdateAccountScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpdateAccountView(userId: userId);
  }
}
