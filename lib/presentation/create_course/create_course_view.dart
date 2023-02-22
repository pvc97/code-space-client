import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/utils/logger/logger.dart';
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

  final List<BaseDropdownItem> items = [
    TeacherModel(id: '1', name: 'Teacher 1', email: 'abc@gmail.com'),
    TeacherModel(id: '2', name: 'Teacher 2', email: 'abc@gmail.com'),
    TeacherModel(id: '3', name: 'Teacher 2', email: 'abc@gmail.com'),
    TeacherModel(id: '4', name: 'Teacher 2', email: 'abc@gmail.com'),
    TeacherModel(id: '5', name: 'Thầy giáo 3', email: 'abc@gmail.com'),
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
                    onChanged: (BaseDropdownItem? value) {
                      logger.d(value?.title);
                    },
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
