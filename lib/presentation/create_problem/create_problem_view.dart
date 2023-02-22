import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:flutter/material.dart';

class CreateProblemView extends StatefulWidget {
  const CreateProblemView({super.key});

  @override
  State<CreateProblemView> createState() => _CreateProblemViewState();
}

class _CreateProblemViewState extends State<CreateProblemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        context: context,
        title: Text(S.of(context).create_new_problem),
      ),
    );
  }
}
