import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';

class UpdateAccountView extends StatefulWidget {
  final String userId;

  const UpdateAccountView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UpdateAccountView> createState() => _UpdateAccountViewState();
}

class _UpdateAccountViewState extends State<UpdateAccountView> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _fullName, _email;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    // final user = context.read<UserCubit>().state.user;
    // if (user == null) {
    //   return;
    // }

    // context.read<UserCubit>().updateProfile(
    //       userId: user.userId,
    //       fullName: _fullName!,
    //       email: _email!,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        context: context,
        title: Text(S.of(context).update_account),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.s20),
            child: Box(
              width: Sizes.s300,
              child: Column(
                children: [
                  Box.h24,
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).full_name,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).full_name_cannot_be_empty;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _fullName = value;
                    },
                  ),
                  Box.h12,
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).email,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).email_cannot_be_empty;
                      }

                      if (!value.isValidEmail()) {
                        return S.of(context).username_only_alphanumeric;
                      }

                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value;
                    },
                  ),
                  Box.h16,
                  // BlocSelector<UserCubit, UserState, StateStatus>(
                  //   selector: (state) => state.stateStatus,
                  //   builder: (context, status) {
                  //     return AppElevatedButton(
                  //       onPressed: _submit,
                  //       text: S.of(context).update,
                  //     );
                  //   },
                  // ),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    child: AppElevatedButton(
                      onPressed: _submit,
                      text: S.of(context).update,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
