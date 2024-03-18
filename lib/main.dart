import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/providers/image_provider.dart';
import 'package:notes_app/providers/localization_provider.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app/utils/localization/app_localization.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(imageProvider.notifier).getImage();
    ref.read(notesProvider.notifier).getNotes();
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
      theme: ThemeData.from(
        textTheme: GoogleFonts.signikaTextTheme(),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurpleAccent, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
