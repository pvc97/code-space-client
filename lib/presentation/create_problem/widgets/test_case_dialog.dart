import 'package:code_space_client/blocs/create_problem/create_problem_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class TestCaseAction {
  const TestCaseAction();
}

class AddTestCaseAction extends TestCaseAction {
  const AddTestCaseAction();
}

class EditTestCaseAction extends TestCaseAction {
  final int index;
  final TestCaseModel testCase;
  const EditTestCaseAction({
    required this.index,
    required this.testCase,
  });
}

void showTestCaseDialog({
  required BuildContext ctx,
  required TestCaseAction action,
  required TextEditingController stdinController,
  required TextEditingController expectedOutputController,
}) {
  final CreateProblemCubit cubit = ctx.read<CreateProblemCubit>();

  bool showTestCase = false;

  if (action is EditTestCaseAction) {
    stdinController.text = action.testCase.stdin;
    expectedOutputController.text = action.testCase.expectedOutput;
    showTestCase = action.testCase.show;
  } else if (action is AddTestCaseAction) {
    stdinController.clear();
    expectedOutputController.clear();
  }

  showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).test_case),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stdinController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: S.of(context).stdin,
              ),
            ),
            Box.h12,
            TextField(
              controller: expectedOutputController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: S.of(context).expected_output,
              ),
            ),
            Box.h12,
            Row(
              children: [
                Text(S.of(context).show_when_wrong),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Checkbox(
                      value: showTestCase,
                      onChanged: (value) {
                        setState(() {
                          showTestCase = !showTestCase;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              final stdin = stdinController.text.trim();
              final expectedOutput = expectedOutputController.text.trim();
              if (stdin.isEmpty || expectedOutput.isEmpty) {
                EasyLoading.showInfo(
                  dismissOnTap: true,
                  duration: const Duration(seconds: 1),
                  S.of(context).please_fill_all_fields,
                );
                return;
              }

              if (action is AddTestCaseAction) {
                cubit.addTestCase(
                  TestCaseModel(
                    stdin: stdin,
                    expectedOutput: expectedOutput,
                    show: showTestCase,
                  ),
                );
              } else if (action is EditTestCaseAction) {
                cubit.editTestCase(
                  action.index,
                  TestCaseModel(
                    stdin: stdin,
                    expectedOutput: expectedOutput,
                    show: showTestCase,
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: Text(S.of(context).ok),
          ),
        ],
      );
    },
  );
}
