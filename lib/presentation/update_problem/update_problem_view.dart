import 'package:code_space_client/presentation/common_widgets/show_update_problem_dialog.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:code_space_client/blocs/update_problem/update_problem_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/presentation/create_problem/widgets/test_case_dialog.dart';

class UpdateProblemView extends StatefulWidget {
  final String problemId;

  const UpdateProblemView({
    Key? key,
    required this.problemId,
  }) : super(key: key);

  @override
  State<UpdateProblemView> createState() => _UpdateProblemViewState();
}

class _UpdateProblemViewState extends State<UpdateProblemView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  final _searchLanguageController = TextEditingController();
  final _stdinController = TextEditingController();
  final _expectedOutputController = TextEditingController();
  final _problemNameController = TextEditingController();
  final _probemPointController = TextEditingController();
  String? _problemName;
  int? _pointPerTestCase;
  // TODO: Add time limit
  BaseDropdownItem? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<UpdateProblemCubit>();
      cubit.getProblem(widget.problemId);
      cubit.getLanguages();
    });
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    if (_selectedLanguage == null) {
      EasyLoading.showInfo(S.of(context).please_select_language,
          dismissOnTap: true);
      return;
    }

    // context.read<UpdateProblemCubit>().updateProblem(
    //       name: _problemName!.trim(),
    //       pointPerTestCase: _pointPerTestCase!,
    //       courseId: widget.courseId,
    //       languageId: int.parse(_selectedLanguage!.id),
    //     );
    showUpdateProblemDialog(
      ctx: context,
      title: S.of(context).update_problem,
      content: S.of(context).update_problem,
      newLanguageId: int.parse(_selectedLanguage!.id),
      newName: _problemName,
      newPointPerTestCase: _pointPerTestCase,
    );
  }

  void _selectPdf() async {
    if (mounted) {
      context.read<UpdateProblemCubit>().setSelectingPdf(true);
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    final MultipartFile file;

    if (result != null) {
      // result.files.single.path return null on web, so I need to use bytes to get the file
      if (kIsWeb) {
        final bytes = result.files.single.bytes;
        file =
            MultipartFile.fromBytes(bytes!, filename: result.files.single.name);
      } else {
        final pdfPath = result.files.single.path;
        file = await MultipartFile.fromFile(pdfPath!);
      }

      // If screen is not mounted, do not update state
      if (mounted) {
        context.read<UpdateProblemCubit>().updatePdfPath(file);
      }
    } else {
      if (mounted) {
        context.read<UpdateProblemCubit>().setSelectingPdf(false);
      }
    }
  }

  @override
  void dispose() {
    _probemPointController.dispose();
    _searchLanguageController.dispose();
    _stdinController.dispose();
    _expectedOutputController.dispose();
    _problemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateProblemCubit, UpdateProblemState>(
          listenWhen: (previous, current) =>
              previous.updateStatus != current.updateStatus,
          listener: (context, state) {
            stateStatusListener(
              context,
              state,
              stateStatus: state.updateStatus,
              onSuccess: () {
                EasyLoading.showSuccess(
                  S.of(context).update_problem_successfully,
                  dismissOnTap: true,
                );
              },
            );
          },
        ),
        BlocListener<UpdateProblemCubit, UpdateProblemState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        BlocListener<UpdateProblemCubit, UpdateProblemState>(
          listenWhen: (previous, current) =>
              previous.problemDetail != current.problemDetail &&
              current.problemDetail != null,
          listener: (context, state) {
            final problem = state.problemDetail!;
            _problemNameController.text = problem.name;
            _probemPointController.text = problem.pointPerTestCase.toString();
            _selectedLanguage = problem.language;
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).update_problem),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          // Don't wrap TextFormField inside ListView because validation will not work
          // if TextFormField isn't visible
          // https://github.com/flutter/flutter/issues/56159
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Sizes.s20),
              child: Box(
                width: Sizes.s400,
                child: Column(
                  children: [
                    BlocBuilder<UpdateProblemCubit, UpdateProblemState>(
                      buildWhen: (previous, current) {
                        return previous.languages != current.languages ||
                            (previous.problemDetail != current.problemDetail &&
                                current.problemDetail != null);
                      },
                      builder: (context, state) {
                        final languages = state.languages;
                        return SearchDropdownButton(
                          initialValue: _selectedLanguage,
                          items: languages,
                          hint: S.of(context).select_languages,
                          searchHint: S.of(context).enter_name_of_language,
                          textEditingController: _searchLanguageController,
                          onChanged: (BaseDropdownItem? value) {
                            _selectedLanguage = value;
                          },
                        );
                      },
                    ),
                    Box.h16,
                    TextFormField(
                      controller: _problemNameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).problem_name,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).problem_name_cannot_be_empty;
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _problemName = value;
                      },
                    ),
                    Box.h16,
                    TextFormField(
                      controller: _probemPointController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).point_per_test_case,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).invalid_point_per_test_case;
                        }

                        final point = int.tryParse(value);
                        if (point == null || point <= 0) {
                          return S.of(context).invalid_point_per_test_case;
                        }

                        return null;
                      },
                      onSaved: (String? value) {
                        if (value == null) return;
                        _pointPerTestCase = int.parse(value);
                      },
                    ),
                    Box.h16,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.s20,
                        vertical: Sizes.s12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(Sizes.s8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  S.of(context).list_of_test_cases,
                                  style: AppTextStyle.textStyle18.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showTestCaseDialog(
                                    ctx: context,
                                    action: AddTestCaseAction(
                                      onAddTestCase: (testCase) {
                                        context
                                            .read<UpdateProblemCubit>()
                                            .addTestCase(testCase);
                                      },
                                    ),
                                    stdinController: _stdinController,
                                    expectedOutputController:
                                        _expectedOutputController,
                                  );
                                },
                                child: Text(S.of(context).add_test_case),
                              ),
                            ],
                          ),
                          BlocSelector<UpdateProblemCubit, UpdateProblemState,
                              Iterable<TestCaseModel>>(
                            selector: (state) => state.currentTestCases,
                            builder: (context, testCases) {
                              if (testCases.isEmpty) {
                                return Box.shrink;
                              }
                              return const Divider();
                            },
                          ),
                          BlocSelector<UpdateProblemCubit, UpdateProblemState,
                              Iterable<TestCaseModel>>(
                            selector: (state) => state.currentTestCases,
                            builder: (context, currentTestCases) {
                              if (currentTestCases.isEmpty) {
                                return Box.shrink;
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: currentTestCases.length,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final testCase =
                                      currentTestCases.elementAt(index);
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              S.of(context).stdin,
                                              style: AppTextStyle.defaultFont,
                                            ),
                                            SelectableText(
                                              testCase.stdin,
                                              style: AppTextStyle.defaultFont,
                                            ),
                                            Box.h4,
                                            Text(
                                              S.of(context).expected_output,
                                              style: AppTextStyle.defaultFont,
                                            ),
                                            SelectableText(
                                              testCase.expectedOutput,
                                              style: AppTextStyle.defaultFont,
                                              // maxLines: 2,
                                            ),
                                            Box.h4,
                                            Row(
                                              children: [
                                                Text(
                                                  S.of(context).show_when_wrong,
                                                  style:
                                                      AppTextStyle.defaultFont,
                                                ),
                                                Box.w4,
                                                testCase.show
                                                    ? const Icon(
                                                        Icons.check_box,
                                                        color: Colors.blue,
                                                      )
                                                    : const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showTestCaseDialog(
                                                ctx: context,
                                                action: EditTestCaseAction(
                                                  index: index,
                                                  testCase: testCase,
                                                  onEditTestCase:
                                                      (index, testCase) {
                                                    context
                                                        .read<
                                                            UpdateProblemCubit>()
                                                        .editTestCase(
                                                            index, testCase);
                                                  },
                                                ),
                                                stdinController:
                                                    _stdinController,
                                                expectedOutputController:
                                                    _expectedOutputController,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blue.shade300,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<UpdateProblemCubit>()
                                                  .removeTestCase(index);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Box.h16,
                    Row(
                      children: [
                        BlocSelector<UpdateProblemCubit, UpdateProblemState,
                            bool>(
                          selector: (state) => state.selectingPdf,
                          builder: (context, selecting) {
                            return ElevatedButton(
                              onPressed: selecting ? null : _selectPdf,
                              child: Text(S.of(context).select_problem_file),
                            );
                          },
                        ),
                        Box.w20,
                        BlocBuilder<UpdateProblemCubit, UpdateProblemState>(
                          builder: (context, state) {
                            // if new pdf file name is null, use pdf path from problem
                            String? fileName =
                                state.problemDetail?.pdfPath.split('/').last;
                            // TODO: Replace last because it can cause error if pdfPath doesn't contain '/'

                            if (state.newPdfFile?.filename != null) {
                              fileName = state.newPdfFile!.filename;
                            }

                            return Expanded(
                              child: Text(
                                fileName ?? '...',
                                maxLines: 2,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Box.h16,
                    BlocBuilder<UpdateProblemCubit, UpdateProblemState>(
                      builder: (context, state) {
                        return FractionallySizedBox(
                          widthFactor: 0.7,
                          child: AppElevatedButton(
                            onPressed: (state.isLoading ||
                                    state.currentTestCases.isEmpty)
                                ? null
                                : _submit,
                            text: S.of(context).update,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
