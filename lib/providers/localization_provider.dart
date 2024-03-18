import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(const Locale('en'));
  void setLocal(String languageCode) {
    state = Locale(languageCode);
  }
}

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, Locale>(
  (ref) => LocalizationNotifier(),
);
