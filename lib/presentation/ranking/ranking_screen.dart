import 'package:code_space_client/blocs/ranking/ranking_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/ranking/ranking_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankingScreen extends StatelessWidget {
  final bool me;
  final String courseId;

  const RankingScreen({
    Key? key,
    this.me = false,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RankingCubit>(
      create: (context) => sl(),
      child: RankingView(me: me, courseId: courseId),
    );
  }
}
