import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:flutter/material.dart';

class CreateCourseView extends StatefulWidget {
  const CreateCourseView({super.key});

  @override
  State<CreateCourseView> createState() => CreateCourseViewState();
}

class CreateCourseViewState extends State<CreateCourseView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _courseName, _courseCode, _accessCode;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();
  }

  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).create_new_course),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).course_name,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).course_name_cannot_be_empty;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _courseName = value;
                    },
                  ),
                  Box.h16,
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).course_code,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).course_code_cannot_be_empty;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _courseCode = value;
                    },
                  ),
                  Box.h16,
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).access_code,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).access_code_cannot_be_empty;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _accessCode = value;
                    },
                  ),
                  Box.h16,
                  SearchDropdownButton(
                    items: items,
                    hint: S.of(context).select_teacher,
                    searchHint: S.of(context).enter_name_or_email_of_teacher,
                    textEditingController: textEditingController,
                  ),
                  Box.h16,
                  AppElevatedButton(
                    onPressed: _submit,
                    text: S.of(context).create,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
