import 'dart:io';
import 'package:code_space_client/blocs/create_problem/create_problem_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:flutter/cupertino.dart';
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

void showTestCaseDialog(BuildContext ctx, TestCaseAction action) {
  final CreateProblemCubit cubit = ctx.read<CreateProblemCubit>();
  String? stdin0, expectedOutput0;

  if (Platform.isIOS || Platform.isWindows) {
    showCupertinoDialog(
        context: ctx,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(S.of(context).test_case),
            content: Padding(
              padding: const EdgeInsets.only(top: Sizes.s12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    placeholder: S.of(context).stdin,
                    onChanged: (value) {
                      stdin0 = value.trim();
                    },
                  ),
                  Box.h12,
                  CupertinoTextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    placeholder: S.of(context).expected_output,
                    onChanged: (value) {
                      expectedOutput0 = value.trim();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  final stdin = stdin0;
                  final expectedOutput = expectedOutput0;
                  if (stdin == null ||
                      stdin.isEmpty ||
                      expectedOutput == null ||
                      expectedOutput.isEmpty) {
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
                          stdin: stdin, expectedOutput: expectedOutput),
                    );
                  } else if (action is EditTestCaseAction) {
                    cubit.editTestCase(
                      action.index,
                      TestCaseModel(
                          stdin: stdin, expectedOutput: expectedOutput),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(S.of(context).ok),
              ),
            ],
          );
        });
  } else {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).test_case),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).stdin,
                ),
                onChanged: (value) {
                  stdin0 = value.trim();
                },
              ),
              Box.h12,
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).expected_output,
                ),
                onChanged: (value) {
                  expectedOutput0 = value.trim();
                },
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
                final stdin = stdin0;
                final expectedOutput = expectedOutput0;
                if (stdin == null ||
                    stdin.isEmpty ||
                    expectedOutput == null ||
                    expectedOutput.isEmpty) {
                  EasyLoading.showInfo(
                    dismissOnTap: true,
                    duration: const Duration(seconds: 1),
                    S.of(context).please_fill_all_fields,
                  );
                  return;
                }

                if (action is AddTestCaseAction) {
                  cubit.addTestCase(
                    TestCaseModel(stdin: stdin, expectedOutput: expectedOutput),
                  );
                } else if (action is EditTestCaseAction) {
                  cubit.editTestCase(
                    action.index,
                    TestCaseModel(stdin: stdin, expectedOutput: expectedOutput),
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
}
