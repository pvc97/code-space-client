import 'package:code_space_client/cubits/problem/problem_cubit.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/utils/extensions/problem_detail_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfTab extends StatefulWidget {
  const PdfTab({super.key});

  @override
  State<PdfTab> createState() => _PdfTabState();
}

class _PdfTabState extends State<PdfTab> with AutomaticKeepAliveClientMixin {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocSelector<ProblemCubit, ProblemState, ProblemDetailModel?>(
      selector: (ProblemState state) => state.problemDetail,
      builder: (context, state) {
        if (state != null) {
          return SfPdfViewer.network(
            state.fullPdfPath,
            key: _pdfViewerKey,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
