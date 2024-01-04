import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/providers/image_provider.dart';
import 'package:notes_app/providers/note_provider.dart';

import 'package:notes_app/screens/add_note_screen.dart';
import 'package:notes_app/modules/note_module.dart';
import 'package:notes_app/screens/settings_screen.dart';
import 'package:notes_app/widgets/note_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

List<Color> mainColors = [
  const Color.fromARGB(255, 166, 234, 255),
  const Color.fromARGB(255, 243, 224, 158),
  const Color.fromARGB(255, 205, 255, 166),
  const Color.fromARGB(255, 242, 156, 224),
];

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Size size;
  List<Note> _notes = [];
  File? _backgroundImage;
  bool _onlyOne = true;

  @override
  void initState() {
    ref.read(notesProvider.notifier).getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _backgroundImage = ref.watch(imageProvider);
    _notes = ref.watch(notesProvider);
    size = MediaQuery.of(context).size;
    final width = (size.width / 2) - 20;
    return Stack(
      children: [
        if (_backgroundImage != null)
          Image.file(
            _backgroundImage!,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        Scaffold(
          backgroundColor: _backgroundImage == null
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.background.withOpacity(.8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Note It',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(0),
                  minimumSize: const Size(40, 40),
                ),
                child: const Icon(Icons.settings),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newOne = await Navigator.of(context)
                  .push<Note>(MaterialPageRoute(builder: (ctx) {
                return const AddNoteScreen();
              }));
              if (newOne == null) {
                return;
              }
              ref.read(notesProvider.notifier).addNote(newOne);
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black87,
            ),
          ),
          body: _notes.isEmpty
              ? const NothingToSeeHere()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StaggeredGrid.count(
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        crossAxisCount: 4,
                        children: _notes.map((note) {
                          double height = (size.height ~/ 2).toDouble();
                          return StaggeredGridTile.fit(
                            crossAxisCellCount: 2,
                            child: Hero(
                              tag: note.id,
                              child: NoteWidget(
                                note: note,
                                height: height,
                                width: width,
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ),
        )
      ],
    );
  }
}

class NothingToSeeHere extends StatelessWidget {
  const NothingToSeeHere({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Note It',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'There is no Notes to see, try to add one',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
