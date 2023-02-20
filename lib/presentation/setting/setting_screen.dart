import 'package:code_space_client/blocs/locale/locale_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/languages.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AdaptiveAppBar(
        context: context,
        title: Text(S.of(context).settings),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context
                    .read<LocaleCubit>()
                    .changeLanguage(Languages.vietnamese);
              },
              child: Text(S.of(context).vietnamese),
            ),
            Box.h12,
            ElevatedButton(
              onPressed: () {
                context.read<LocaleCubit>().changeLanguage(Languages.english);
              },
              child: Text(S.of(context).english),
            ),
          ],
        ),
      ),
    );
  }
}
