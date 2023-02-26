import 'package:code_space_client/blocs/problem/problem_cubit.dart';
import 'package:code_space_client/constants/app_color.dart';
import 'package:code_space_client/constants/app_sizes.dart';
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
      builder: (context, problem) {
        if (problem != null) {
          return Stack(
            children: [
              SfPdfViewer.network(
                problem.fullPdfPath,
                key: _pdfViewerKey,
                // Use PdfInteractionMode.pan and set scrollBehavior in main
                // to enable changing page with mouse
                interactionMode: PdfInteractionMode.pan,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(Sizes.s8),
                  padding: const EdgeInsets.all(Sizes.s4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.shade100,
                    borderRadius: BorderRadius.circular(Sizes.s8),
                    border: Border.all(
                      color: AppColor.primaryColor,
                      width: Sizes.s1,
                    ),
                  ),
                  child: Text(problem.language.name),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
