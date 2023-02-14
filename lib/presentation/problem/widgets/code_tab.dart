import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

class CodeTab extends StatefulWidget {
  final CodeController codeController;

  const CodeTab({
    Key? key,
    required this.codeController,
  }) : super(key: key);

  @override
  State<CodeTab> createState() => _CodeTabState();
}

class _CodeTabState extends State<CodeTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CodeField(
      controller: widget.codeController,
      expands: true,
    );
  }
}
