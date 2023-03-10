import 'package:flutter/material.dart';

class UpdateAccountView extends StatefulWidget {
  final String userId;

  const UpdateAccountView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UpdateAccountView> createState() => _UpdateAccountViewState();
}

class _UpdateAccountViewState extends State<UpdateAccountView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
