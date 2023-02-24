import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:code_space_client/blocs/create_problem/create_problem_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/presentation/create_problem/widgets/test_case_dialog.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';

class CreateProblemView extends StatefulWidget {
  final bool me;
  final String courseId;
  final VoidCallback? onProblemCreated;

  const CreateProblemView({
    Key? key,
    required this.me,
    required this.courseId,
    this.onProblemCreated,
  }) : super(key: key);

  @override
  State<CreateProblemView> createState() => _CreateProblemViewState();
}

class _CreateProblemViewState extends State<CreateProblemView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  final _searchLanguageController = TextEditingController();
  final _stdinController = TextEditingController();
  final _expectedOutputController = TextEditingController();
  String? _problemName;
  int? _pointPerTestCase;
  // TODO: Add time limit
  BaseDropdownItem? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateProblemCubit>().getLanguages();
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

    context.read<CreateProblemCubit>().createProblem(
          name: _problemName!.trim(),
          pointPerTestCase: _pointPerTestCase!,
          courseId: widget.courseId,
          languageId: int.parse(_selectedLanguage!.id),
        );
  }

  void _selectPdf() async {
    if (mounted) {
      context.read<CreateProblemCubit>().setSelectingPdf(true);
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
        context.read<CreateProblemCubit>().updatePdfPath(file);
      }
    } else {
      if (mounted) {
        context.read<CreateProblemCubit>().setSelectingPdf(false);
      }
    }
  }

  @override
  void dispose() {
    _searchLanguageController.dispose();
    _stdinController.dispose();
    _expectedOutputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        const BlocListener<CreateProblemCubit, CreateProblemState>(
          listener: stateStatusListener,
        ),
        BlocListener<CreateProblemCubit, CreateProblemState>(
          listenWhen: (previous, current) =>
              previous.problemId != current.problemId,
          listener: (context, state) {
            final problemId = state.problemId;
            if (problemId != null) {
              // When problem is created, reload list problem in course detail
              // and navigate to problem detail page
              widget.onProblemCreated?.call();

              context.goNamed(
                AppRoute.problem.name,
                params: {
                  'courseId': widget.courseId,
                  'problemId': problemId,
                },
                queryParams: widget.me ? {'me': 'true'} : {},
              );
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AdaptiveAppBar(
            context: context,
            title: Text(S.of(context).create_new_problem),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(Sizes.s20),
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    BlocSelector<CreateProblemCubit, CreateProblemState,
                        Iterable<LanguageModel>>(
                      selector: (state) => state.languages,
                      builder: (context, teachers) {
                        return SearchDropdownButton(
                          items: teachers,
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
                              Text(S.of(context).list_of_test_cases),
                              ElevatedButton(
                                onPressed: () {
                                  showTestCaseDialog(
                                    ctx: context,
                                    action: const AddTestCaseAction(),
                                    stdinController: _stdinController,
                                    expectedOutputController:
                                        _expectedOutputController,
                                  );
                                },
                                child: Text(S.of(context).add_test_case),
                              ),
                            ],
                          ),
                          BlocSelector<CreateProblemCubit, CreateProblemState,
                              Iterable<TestCaseModel>>(
                            selector: (state) => state.testCases,
                            builder: (context, testCases) {
                              if (testCases.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return const Divider();
                            },
                          ),
                          BlocSelector<CreateProblemCubit, CreateProblemState,
                              Iterable<TestCaseModel>>(
                            selector: (state) => state.testCases,
                            builder: (context, testCases) {
                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: testCases.length,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final testCase = testCases.elementAt(index);
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(S.of(context).stdin),
                                          SelectableText(testCase.stdin),
                                          Box.h4,
                                          Text(S.of(context).expected_output),
                                          SelectableText(
                                              testCase.expectedOutput),
                                          Box.h4,
                                          Row(
                                            children: [
                                              Text(S
                                                  .of(context)
                                                  .show_when_wrong),
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
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showTestCaseDialog(
                                                ctx: context,
                                                action: EditTestCaseAction(
                                                  index: index,
                                                  testCase: testCase,
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
                                                  .read<CreateProblemCubit>()
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
                        BlocSelector<CreateProblemCubit, CreateProblemState,
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
                        BlocSelector<CreateProblemCubit, CreateProblemState,
                            MultipartFile?>(
                          selector: (state) => state.pdfFile,
                          builder: (context, pdfFile) {
                            return Expanded(
                              child: Text(
                                pdfFile?.filename ?? '...',
                                maxLines: 2,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Box.h16,
                    BlocBuilder<CreateProblemCubit, CreateProblemState>(
                      builder: (context, state) {
                        final testCases = state.testCases;
                        final pdfPath = state.pdfFile;

                        return AppElevatedButton(
                          onPressed: (testCases.isNotEmpty && pdfPath != null)
                              ? _submit
                              : null,
                          text: S.of(context).create,
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
