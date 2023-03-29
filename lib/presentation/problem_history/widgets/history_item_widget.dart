import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/date_time_ext.dart';
import 'package:code_space_client/utils/extensions/language_ext.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:code_space_client/models/problem_history_model.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class HistoryItemWidget extends StatefulWidget {
  final ProblemHistoryModel history;
  final String problemId;
  final String courseId;
  final bool me;

  const HistoryItemWidget({
    Key? key,
    required this.history,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  State<HistoryItemWidget> createState() => _HistoryItemWidgetState();
}

class _HistoryItemWidgetState extends State<HistoryItemWidget>
    with SingleTickerProviderStateMixin {
  late final CodeController _codeController;

  late AnimationController _controller;
  late Animation<double> _iconTurns;

  final Animatable<double> _iconTurnTween = Tween<double>(begin: 0.0, end: 0.5)
      .chain(CurveTween(curve: Curves.fastOutSlowIn));

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: widget.history.sourceCode,
      language: widget.history.language.highlight,
    );

    _controller =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = _controller.drive(_iconTurnTween);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoute.problemResult.name,
          params: {
            'courseId': widget.courseId,
            'problemId': widget.problemId,
            'submitId': widget.history.submissionId,
          },
          queryParams: widget.me ? {'me': 'true'} : {},
        );
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(Sizes.s12),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.history.createdAt.toLocal().hhmmddMMyyyy,
                    style: AppTextStyle.textStyle18.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Box.w8,
                  widget.history.completed
                      ? const Icon(
                          Bootstrap.check2_circle,
                          color: AppColor.primaryColor,
                        )
                      : Box.shrink,
                ],
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${S.of(context).total_point}: ${widget.history.totalPoints}',
                    style: AppTextStyle.defaultFont,
                  ),
                  Text(
                    '${S.of(context).correct}: ${widget.history.correctTestCases} / ${widget.history.numberOfTestCases}',
                    style: AppTextStyle.defaultFont,
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });

                  if (_isExpanded) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
                icon: RotationTransition(
                  turns: _iconTurns,
                  child: const Icon(Icons.expand_more),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? CodeTheme(
                      data: const CodeThemeData(styles: monokaiSublimeTheme),
                      child: CodeField(
                        readOnly: true,
                        controller: _codeController,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(Sizes.s12),
                            bottomRight: Radius.circular(Sizes.s12),
                          ),
                        ),
                      ),
                    )
                  : Box.shrink,
            ),
          ],
        ),
      ),
    );
  }
}
