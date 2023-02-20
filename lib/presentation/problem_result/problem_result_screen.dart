import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/problem_result/problem_result_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_scaffold.dart';
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
          child: AppScaffold(
            appBar: AdaptiveAppBar(
              context: context,
              title: Text(S.of(context).problem_result),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Sizes.s20),
              child: BlocBuilder<ProblemResultCubit, ProblemResultState>(
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
                        Text(
                          '${S.of(context).total_point}: ${submission.totalPoint}',
                          style: const TextStyle(
                            fontSize: Sizes.s32,
                          ),
                        ),
                        Box.h8,
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: submission.results.length,
                            itemBuilder: (context, index) {
                              final result = submission.results[index];
                              return Card(
                                child: ListTile(
                                  leading: Text('Input: ${result.stdin} '),
                                  title: Text(
                                      'Expected Output: ${result.expectedOutput}'),
                                  subtitle:
                                      Text('Actual Output: ${result.output}'),
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
          ),
        );
      }),
    );
  }
}
