import 'package:code_space_client/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const AppElevatedButton({
    Key? key,
    this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(Sizes.s20)),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
