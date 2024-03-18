import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/providers/image_provider.dart';
import 'package:notes_app/providers/localization_provider.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app/screens/splash_screen.dart';
import 'package:notes_app/utils/localization/app_localization.dart';
import 'package:notes_app/utils/thems.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}



class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<void> getAll(WidgetRef ref) async {

      await ref.read(notesProvider.notifier).getNotes();
      await ref.read(localizationProvider.notifier).getLocale();
      await ref.read(imageProvider.notifier).getImage();

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: getAll(ref),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snap.connectionState == ConnectionState.done) {
            return const NoteIt();
          }
          return const SplashScreen();
        });
  }
}

class NoteIt extends ConsumerWidget {
  const NoteIt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      locale: ref.watch(localizationProvider),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // localeListResolutionCallback: (deviceLocals, supportedLocals) {
      //   for (var local in supportedLocals) {
      //     if (deviceLocals != null) {
      //       for (var deviceLocal in deviceLocals) {
      //         if (deviceLocal.languageCode == local.languageCode) {
      //           return deviceLocal;
      //         }
      //       }
      //     }
      //   }
      //   return supportedLocals.first;
      // },
      title: 'Notes',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}

