import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_images.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/ranking/ranking_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:lottie/lottie.dart';

class RankingView extends StatefulWidget {
  final bool me;
  final String courseId;

  const RankingView({
    Key? key,
    required this.me,
    required this.courseId,
  }) : super(key: key);

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RankingCubit>().getRankings(courseId: widget.courseId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    context.read<RankingCubit>().loadMoreRankings(courseId: widget.courseId);
  }

  void _refreshRankings() {
    context.read<RankingCubit>().refreshRankings(courseId: widget.courseId);
  }

  Widget _buildBadge(int index) {
    switch (index) {
      case 0:
        return Lottie.asset(
          AppImages.top1,
          width: Sizes.s64,
        );
      case 1:
        return Lottie.asset(
          AppImages.top2,
          width: Sizes.s64,
        );
      case 2:
        return Lottie.asset(
          AppImages.top3,
          width: Sizes.s64,
        );
      default:
        return Container(
          width: Sizes.s56,
          height: Sizes.s56,
          margin: const EdgeInsets.only(
            left: Sizes.s8,
            top: Sizes.s4,
            bottom: Sizes.s4,
          ),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.shade50,
            borderRadius: BorderRadius.circular(Sizes.s32),
            border: Border.all(
              color: AppColor.primaryColor,
              width: Sizes.s3,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: AppTextStyle.textStyle18,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: const [
        BlocListener<RankingCubit, RankingState>(
          listener: stateStatusListener,
        ),
      ],
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AdaptiveAppBar(
            context: context,
            title: Text(S.of(context).ranking),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _refreshRankings();
            },
            child: BlocBuilder<RankingCubit, RankingState>(
              buildWhen: (previous, current) =>
                  previous.rankings != current.rankings,
              builder: (context, state) {
                final rankings = state.rankings;

                return ListView.builder(
                  padding: const EdgeInsets.all(Sizes.s20),
                  itemCount: rankings.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == rankings.length) {
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

                    final item = rankings[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.s8),
                        child: Row(
                          children: [
                            _buildBadge(index),
                            Box.w8,
                            Expanded(
                              child: Text(
                                item.studentName,
                                style: AppTextStyle.textStyle18,
                              ),
                            ),
                            Text(
                              '${item.totalPoint} ${S.of(context).points}',
                              style: AppTextStyle.textStyle16,
                            ),
                            Box.w8,
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
