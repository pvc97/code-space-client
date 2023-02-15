import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_highlight/themes/monokai-sublime.dart';

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

    // Have to wrap the CodeField in a CodeTheme to enable syntax highlighting
    return CodeTheme(
      data: const CodeThemeData(styles: monokaiSublimeTheme),
      child: CodeField(
        controller: widget.codeController,
        expands: true,
      ),
    );
  }
}
