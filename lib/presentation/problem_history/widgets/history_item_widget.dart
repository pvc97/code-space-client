import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/utils/extensions/date_time_ext.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/models/problem_history_model.dart';

class HistoryItemWidget extends StatefulWidget {
  final ProblemHistoryModel history;

  const HistoryItemWidget({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  State<HistoryItemWidget> createState() => _HistoryItemWidgetState();
}

class _HistoryItemWidgetState extends State<HistoryItemWidget> {
  late final CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(text: widget.history.sourceCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.history.createdAt.toLocal().type1,
        style: AppTextStyle.textStyle18,
      ),
      children: [
        CodeField(
          readOnly: true,
          controller: _codeController,
        ),
      ],
    );
  }
}
