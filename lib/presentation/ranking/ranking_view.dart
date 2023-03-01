import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/blocs/ranking/ranking_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';

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
                      child: ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(item.studentName),
                        subtitle: Text('${item.totalPoint}'),
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
