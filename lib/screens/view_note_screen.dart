import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/providers/image_provider.dart';
import 'package:notes_app/providers/note_provider.dart';

import '../modules/note_module.dart';

class NoteViewScreen extends ConsumerStatefulWidget {
  NoteViewScreen(
      {required this.note,
      required this.color,
      this.editMode = false,
      super.key});

  bool editMode;
  Note note;
  final Color color;

  @override
  ConsumerState<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends ConsumerState<NoteViewScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();
  File? _backgroundImage;

  @override
  void initState() {
    _title.text = widget.note.title;
    _body.text = widget.note.body;
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _backgroundImage = ref.read(imageProvider);
    return Stack(
      children: [
        if (_backgroundImage != null)
          Image.file(_backgroundImage!,
              height: double.infinity, fit: BoxFit.cover),
        Scaffold(
          backgroundColor: _backgroundImage == null
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.background.withOpacity(.8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: widget.editMode
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.editMode = false;
                        _title.text = widget.note.title;
                        _body.text = widget.note.body;
                      });
                    },
                    icon: const Icon(Icons.close))
                : null,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.editMode == true) {
                        if (_body.text.trim().isEmpty ||
                            _title.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('title or body is empty!')));
                          setState(() {
                            widget.editMode = false;
                          });
                          return;
                        }
                        final newNote = widget.note
                            .copyOf(newTitle: _title.text, newBody: _body.text);
                        ref.read(notesProvider.notifier).editNote(newNote);
                        widget.note = newNote;
                        widget.editMode = false;
                      } else {
                        widget.editMode = true;
                      }
                    });
                  },
                  icon: Icon(
                    widget.editMode ? Icons.done : Icons.edit,
                  ))
            ],
          ),
          body: Hero(
            tag: widget.note.id,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(18),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: widget.note.image == null
                      ? null
                      : DecorationImage(
                          image: FileImage(widget.note.image!),
                          fit: BoxFit.cover,
                          opacity: .45),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      widget.note.color == null
                          ? widget.color.withOpacity(.6)
                          : widget.note.color!.withOpacity(.6),
                      widget.note.color == null
                          ? widget.color.withOpacity(.4)
                          : widget.note.color!.withOpacity(.4)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.editMode)
                          TextField(
                            cursorHeight: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .fontSize,
                            controller: _title,
                            maxLines: null,
                            minLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Colors.white70,
                                ),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                fillColor: widget.note.image == null
                                    ? Colors.black12
                                    : Colors.black38,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none)),
                          ),
                        if (!widget.editMode)
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: widget.note.image == null
                                    ? Colors.black12
                                    : Colors.black38,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              widget.note.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat.MMMMEEEEd().format(widget.note.createdAt),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (widget.editMode)
                          TextField(
                            controller: _body,
                            maxLines: null,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onBackground,
                                ),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                fillColor: widget.note.image == null
                                    ? Colors.black12
                                    : Colors.black38,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none)),
                          ),
                        if (!widget.editMode)
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: widget.note.image == null
                                  ? Colors.black12
                                  : Colors.black38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.note.body,
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
