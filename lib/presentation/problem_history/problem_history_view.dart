import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/problem_history/problem_history_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/empty_widget.dart';
import 'package:code_space_client/presentation/problem_history/widgets/history_item_widget.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProblemHistoryView extends StatefulWidget {
  final String problemId;
  final String courseId;
  final bool me;

  const ProblemHistoryView({
    Key? key,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  State<ProblemHistoryView> createState() => ProblemHistoryViewState();
}

class ProblemHistoryViewState extends State<ProblemHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ProblemHistoryCubit>()
          .getProblemHistories(problemId: widget.problemId);
    });
  }

  void _loadMore() {
    context
        .read<ProblemHistoryCubit>()
        .loadMoreHistories(problemId: widget.problemId);
  }

  void _refreshHistories() {
    context
        .read<ProblemHistoryCubit>()
        .refreshHistories(problemId: widget.problemId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: const [
        BlocListener<ProblemHistoryCubit, ProblemHistoryState>(
          listener: stateStatusListener,
        ),
      ],
      child: BaseScaffold(
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).problem_history),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _refreshHistories();
          },
          child: BlocBuilder<ProblemHistoryCubit, ProblemHistoryState>(
            buildWhen: (previous, current) =>
                previous.problemHistories != current.problemHistories,
            builder: (context, state) {
              final histories = state.problemHistories;

              if (state.stateStatus == StateStatus.initial) {
                return const SizedBox.shrink();
              }

              if (histories.isEmpty) {
                String message = S.of(context).no_submission_history_yet;

                return Center(
                  child: EmptyWidget(message: message),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(Sizes.s20),
                itemCount: histories.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == histories.length) {
                    // Check stateStatus to avoid infinite loop call loadMore
                    if (state.isLoadMoreDone ||
                        state.stateStatus != StateStatus.success) {
                      return const SizedBox.shrink();
                    }

                    // Loadmore when last item is rendered
                    _loadMore();

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final history = histories[index];
                  // return Card(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(Sizes.s8),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             history.createdAt.toLocal().toString(),
                  //             style: AppTextStyle.textStyle18,
                  //           ),
                  //         ),
                  //         if (history.completed)
                  //           const Icon(
                  //             Bootstrap.check2_circle,
                  //             color: AppColor.primaryColor,
                  //           )
                  //       ],
                  //     ),
                  //   ),
                  // );
                  return HistoryItemWidget(history: history);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
