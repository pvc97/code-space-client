import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/data/data_provider/services/locale_service.dart';
import 'package:code_space_client/models/languages.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleService localeService;

  LocaleCubit({
    Languages? initLanguage,
    required this.localeService,
  }) : super(LocaleState.initial(initLanguage: initLanguage));

  void changeLanguage(Languages language) async {
    await localeService.saveLocaleCode(language.code);
    emit(
      state.copyWith(
        locale: Locale.fromSubtags(languageCode: language.code),
      ),
    );
  }
}
