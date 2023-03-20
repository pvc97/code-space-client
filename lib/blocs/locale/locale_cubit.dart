import 'package:code_space_client/data/repositories/locale_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/models/languages.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleRepository localeRepository;

  LocaleCubit({
    Languages? initLanguage,
    required this.localeRepository,
  }) : super(LocaleState.initial(initLanguage: initLanguage));

  void changeLanguage(Languages language) async {
    await localeRepository.saveLocaleCode(language.code);
    emit(
      state.copyWith(
        locale: Locale.fromSubtags(languageCode: language.code),
      ),
    );
  }
}
