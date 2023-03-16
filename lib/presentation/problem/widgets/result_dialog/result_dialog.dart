import 'package:code_space_client/constants/app_images.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'result_dialog_cubit.dart';

void showResultDialog({
  required BuildContext ctx,
  required VoidCallback onDetailPressed,
}) {
  final resultCubit = ctx.read<ResultDialogCubit>();

  showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(Sizes.s12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.s12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ResultDialogCubit, ResultDialogState>(
              bloc: resultCubit,
              builder: (context, state) {
                if (state.results.isEmpty) {
                  return const SizedBox(
                    width: Sizes.s48,
                    height: Sizes.s60,
                    child: Center(
                      child: Box(
                        width: Sizes.s44,
                        height: Sizes.s44,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state.correctAll) {
                  return Lottie.asset(
                    AppImages.correctAll,
                    height: Sizes.s60,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.s12),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: state.results.map((result) {
                      return Lottie.asset(
                        result ? AppImages.correct : AppImages.wrong,
                        width: Sizes.s48,
                        height: Sizes.s48,
                        repeat: false,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            BlocBuilder<ResultDialogCubit, ResultDialogState>(
              bloc: resultCubit,
              builder: (context, state) {
                return Text(
                  '${state.results.length} / ${state.totalTestCases}',
                  style: AppTextStyle.defaultFont.copyWith(
                    fontSize: Sizes.s16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Box.h12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: const BoxConstraints(minWidth: Sizes.s108),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.s8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: AppTextStyle.defaultFont,
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: Sizes.s108),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.s8),
                      ),
                    ),
                    onPressed: () {
                      onDetailPressed();
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).detail,
                      style: AppTextStyle.defaultFont,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
