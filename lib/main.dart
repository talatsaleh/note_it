import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/providers/image_provider.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),

    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(imageProvider.notifier).getImage();
    ref.read(notesProvider.notifier).getNotes();
    return MaterialApp(
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
