import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/widgets/adaptive_app_bar.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _fullName, _email;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    // TODO: Handle sign up
    logger.d('$_fullName, $_email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).profile),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: SizedBox(
            width: 300.0,
            child: ListView(
              shrinkWrap: true,
              children: [
                CircleAvatar(
                  radius: Sizes.p64,
                  backgroundColor: Colors.pink[200],
                  child: const FlutterLogo(size: Sizes.p64),
                ),
                gapH24,
                TextFormField(
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
                gapH12,
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.of(context).email,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).email_cannot_be_empty;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _email = value;
                  },
                ),
                gapH12,
                ElevatedButton(
                  onPressed: _submit,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                    child: Text(S.of(context).update),
                  ),
                ),
                gapH24,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(S.of(context).change_password),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
