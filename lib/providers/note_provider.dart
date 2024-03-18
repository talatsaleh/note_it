import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as app_path;

import '../modules/note_module.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  Future<void> getNotes() async {
    final db = await _getDataBase();
    final data = await db.query('notes');
    print(data);
    state = data
        .map(
          (note) => Note(
            id: note['created_at'] as String,
            body: note['body'] as String,
            createdAt: DateTime.fromMicrosecondsSinceEpoch(
                int.parse(note['created_at'] as String)),
            title: note['title'] as String,
            color: note['color'] == 'null'
                ? null
                : Color(
                    int.parse(note['color'] as String),
                  ),
            image:
                note['image'] == 'null' ? null : File(note['image'] as String),
          ),
        )
        .toList();
  }

  Future<sql.Database> _getDataBase() async {
    final dbPath = await sql.getDatabasesPath();

    final db = await sql.openDatabase(
      path.join(dbPath, 'Notes'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE notes (created_at INT PRIMARY KEY, title TEXT, body TEXT, image TEXT, color TEXT)');
      },
      version: 1,
    );
    return db;
  }

  void addNote(Note note) async {
    // print('color is ${note.color?.value ?? 'null'}');
    if (note.image == null) {
      state = [...state, note];
    } else {
      final appDir = await app_path.getApplicationDocumentsDirectory();
      final imageName = path.basename(note.image!.path);
      final imagePath = await note.image!.copy('${appDir.path}/$imageName');
      note = note.copyOf(newImage: imagePath);
      // print(note.image!.path);
      state = [...state, note];
    }
    final db = await _getDataBase();
    db.insert('notes', {
      'title': note.title,
      'body': note.body,
      'created_at': note.createdAt.microsecondsSinceEpoch,
      'color': note.color?.value.toString() ?? 'null',
      'image': note.image?.path ?? 'null',
    });
  }

  void removeNote(Note note) async {
    final db = await _getDataBase();
    await db.delete('notes', where: 'created_at = ?', whereArgs: [note.id]);
    if (note.image != null) {
      await note.image!.delete();
    }
    getNotes();
  }

  void editNote(Note note) async {
    final index = state.indexWhere((notes) => notes.id == note.id);
    final db = await _getDataBase();
    db.update(
      'notes',
      {
        'title': note.title,
        'body': note.body,
        'color': note.color?.value ?? 'null',
      },
      where: 'created_at = ?',
      whereArgs: [int.parse(note.id)],
    );
    state[index] = note;
  }
}

final notesProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>((ref) => NoteNotifier());
