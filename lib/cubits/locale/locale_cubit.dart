import 'package:code_space_client/models/languages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'intl_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState.initial());

  void changeLanguage(Languages languages) {
    emit(
      state.copyWith(
        locale: Locale.fromSubtags(languageCode: languages.code),
      ),
    );
  }
}
