import 'package:code_space_client/blocs/update_problem/update_problem_cubit.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showUpdateProblemDialog({
  required BuildContext ctx,
  required String title,
  required String content,
  int? newLanguageId,
  String? newName,
  int? newPointPerTestCase,
}) {
  final cubit = ctx.read<UpdateProblemCubit>();
  Widget? content;

  final problemDetail = cubit.state.problemDetail;

  if (problemDetail == null) {
    EasyLoading.showError(
      S.of(ctx).an_error_occurred,
      dismissOnTap: true,
    );
    return;
  }

  bool languageChanged = false;
  if (newLanguageId != null &&
      newLanguageId != problemDetail.language.languageId) {
    languageChanged = true;
  }

  bool testCasesChanged = false;
  final currentTestCases = cubit.state.currentTestCases;
  final oldTestCases = cubit.state.problemDetail?.testCases ?? {};
  if (currentTestCases.length != oldTestCases.length ||
      {...currentTestCases, ...oldTestCases}.length != oldTestCases.length) {
    testCasesChanged = true;
  }

  bool pdfChanged = false;
  if (cubit.state.newPdfFile != null) {
    pdfChanged = true;
  }

  bool deleteAllSubmissionWhenPdfChanged = false;
  if (languageChanged || testCasesChanged || pdfChanged) {
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (languageChanged)
          Text(
            S.of(ctx).language_has_changed,
            style: AppTextStyle.textStyle20.copyWith(
              color: AppColor.primaryColor,
              overflow: TextOverflow.visible,
            ),
          ),
        if (testCasesChanged)
          Text(
            S.of(ctx).test_cases_have_changed,
            style: AppTextStyle.textStyle20.copyWith(
              color: AppColor.primaryColor,
              overflow: TextOverflow.visible,
            ),
          ),
        if (languageChanged || testCasesChanged)
          Align(
            alignment: Alignment.center,
            child: Text(
              S.of(ctx).all_submission_will_be_deleted,
              style: AppTextStyle.textStyle16.copyWith(
                color: AppColor.popupDeleteColor,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        if (pdfChanged && (!languageChanged && !testCasesChanged))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(ctx).pdf_file_has_changed,
                style: AppTextStyle.textStyle20.copyWith(
                  color: AppColor.primaryColor,
                  overflow: TextOverflow.visible,
                ),
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxListTile(
                    title: Text(
                      S.of(ctx).do_you_delete_all_submission,
                      style: AppTextStyle.defaultFont.copyWith(
                        overflow: TextOverflow.visible,
                        color: AppColor.popupDeleteColor,
                      ),
                    ),
                    value: deleteAllSubmissionWhenPdfChanged,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        deleteAllSubmissionWhenPdfChanged = value ?? false;
                      });
                    },
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              S.of(context).cancel,
              style: AppTextStyle.defaultFont,
            ),
          ),
          TextButton(
            onPressed: () {
              cubit.updateProblem(
                courseId: problemDetail.courseId,
                problemId: problemDetail.id,
                newLanguageId: languageChanged ? newLanguageId : null,
                newName: newName,
                newPointPerTestCase: newPointPerTestCase,
                newFile: pdfChanged ? cubit.state.newPdfFile : null,
                newTestCases: testCasesChanged ? currentTestCases : null,
                pdfDeleteSubmission: deleteAllSubmissionWhenPdfChanged,
              );

              Navigator.pop(context);
            },
            child: Text(
              S.of(context).ok,
              style: AppTextStyle.defaultFont,
            ),
          ),
        ],
      );
    },
  );
}
