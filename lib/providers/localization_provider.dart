import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(const Locale('en'));

  Future <void> getLocale() async {
    final appDir = await getApplicationDocumentsDirectory();
    final languageFile = File('${appDir.path}/language.txt');
    if (languageFile.existsSync()) {
      String langCode = await languageFile.readAsString();
      state = Locale(langCode);
    }
  }

  void setLocal(String languageCode) async {
    final appDir = await getApplicationDocumentsDirectory();
    final languageFile = File('${appDir.path}/language.txt');
    await languageFile.writeAsString(languageCode);
    state = Locale(languageCode);
  }
}

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, Locale>(
  (ref) => LocalizationNotifier(),
);
