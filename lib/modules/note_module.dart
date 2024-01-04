import 'dart:io';
import 'package:flutter/material.dart';

class Note {
  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.image,
    this.color,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final File? image;
  final Color? color;

  Note copyOf(
      {String? newTitle, String? newBody, Color? newColor, File? newImage}) {
    return Note(
        id: id,
        title: newTitle ?? title,
        body: newBody ?? body,
        createdAt: createdAt,
        color: newColor ?? color,
        image: newImage ?? image);
  }
}
