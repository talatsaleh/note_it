
import 'package:flutter/material.dart';
import 'package:notes_app/utils/thems.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note It',
      theme: appTheme,
      home: Scaffold(
        body: Center(
          child: Text('Note It',style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: Theme.of(context).colorScheme.background,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
    );
  }
}
