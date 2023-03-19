import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/problem_result/problem_result_cubit.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProblemResultScreen extends StatefulWidget {
  final String submitId;

  const ProblemResultScreen({
    Key? key,
    required this.submitId,
  }) : super(key: key);

  @override
  State<ProblemResultScreen> createState() => _ProblemResultScreenState();
}

class _ProblemResultScreenState extends State<ProblemResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProblemResultCubit>(
      create: (context) => sl()..getSubmissionResult(widget.submitId),
      child: Builder(builder: (context) {
        return BlocListener<ProblemResultCubit, ProblemResultState>(
          listener: stateStatusListener,
          child: BaseScaffold(
            appBar: AdaptiveAppBar(
              context: context,
              title: Text(S.of(context).problem_result),
            ),
            body: BlocBuilder<ProblemResultCubit, ProblemResultState>(
              builder: (context, state) {
                if (state.stateStatus == StateStatus.error) {
                  return Center(
                    child: Text(state.error?.message ?? ''),
                  );
                } else if (state.stateStatus == StateStatus.success) {
                  final submission = state.submission!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Sizes.s20,
                          left: Sizes.s20,
                          right: Sizes.s20,
                        ),
                        child: Text(
                          '${S.of(context).total_point}: ${submission.totalPoints}',
                          style: AppTextStyle.defaultFont.copyWith(
                            fontSize: Sizes.s32,
                          ),
                        ),
                      ),
                      Box.h8,
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: Sizes.s20,
                            right: Sizes.s20,
                            bottom: Sizes.s20,
                          ),
                          itemCount: submission.results.length,
                          itemBuilder: (context, index) {
                            final result = submission.results[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.s24,
                                  vertical: Sizes.s12,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      S.of(context).stdin,
                                      style: AppTextStyle.textStyle18.copyWith(
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SelectableText(
                                      result.stdin,
                                      style: AppTextStyle.defaultFont.copyWith(
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    const Divider(color: AppColor.primaryColor),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).expected_output,
                                          style:
                                              AppTextStyle.textStyle18.copyWith(
                                            color: AppColor.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SelectableText(
                                          result.expectedOutput,
                                          style:
                                              AppTextStyle.defaultFont.copyWith(
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        const Divider(
                                            color: AppColor.primaryColor),
                                        Text(
                                          S.of(context).actual_output,
                                          style:
                                              AppTextStyle.textStyle18.copyWith(
                                            color: AppColor.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SelectableText(
                                          result.output,
                                          style:
                                              AppTextStyle.defaultFont.copyWith(
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  result.correct
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: result.correct
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      }),
    );
  }
}
