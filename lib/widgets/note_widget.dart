import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/providers/localization_provider.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/utils/localization/detect_language.dart';

import '../modules/note_module.dart';
import '../providers/note_provider.dart';
import '../screens/view_note_screen.dart';
import '../utils/localization/app_localization.dart';

extension on DateTime {
  bool isToday() {
    DateTime today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }
}

class NoteWidget extends ConsumerStatefulWidget {
  const NoteWidget({
    super.key,
    required this.note,
    required this.height,
    required this.width,
  });

  final Note note;
  final double height;
  final double width;

  @override
  ConsumerState<NoteWidget> createState() => _NoteWidgetNotifier();
}

class _NoteWidgetNotifier extends ConsumerState<NoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ColorTween _animation;
  late Color color;
  late bool isEnglish;
  late bool isDefLang;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    color = mainColors[Random().nextInt(4)];
    super.initState();
  }

  String get languageCode {
    return detectLanguage(string: widget.note.title);
  }

  @override
  Widget build(BuildContext context) {
    isEnglish = ref.read(localizationProvider).languageCode == 'en';
    isDefLang = ref.read(localizationProvider).languageCode !=
        detectLanguage(string: widget.note.title);
    var tapPosition;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return NoteViewScreen(
              note: widget.note, color: widget.note.color ?? color);
        }));
      },
      onTapDown: (val) {
        tapPosition = val.globalPosition;
      },
      onLongPress: () {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        showMenu(
          context: context,
          position: RelativeRect.fromRect(
              tapPosition & const Size(20, 20), Offset.zero & overlay.size),
          items: [
            PopupMenuItem(
              onTap: () {
                ref.read(notesProvider.notifier).removeNote(widget.note);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.close),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("remove".tr(context))
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return NoteViewScreen(
                    note: widget.note,
                    editMode: true,
                    color: widget.note.color ?? color,
                  );
                }));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("edit".tr(context)),
                ],
              ),
            )
          ],
        );
      },
      child: Container(
        constraints: BoxConstraints(
            maxHeight: widget.height,
            minHeight: (widget.height ~/ 3).toDouble()),
        padding:
            const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
        decoration: BoxDecoration(
            image: widget.note.image == null
                ? null
                : DecorationImage(
                    image: FileImage(widget.note.image!),
                    fit: BoxFit.cover,
                    opacity: .45),
            color: widget.note.color ?? color,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment:
              isDefLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textDirection: languageCode == 'ar'
                  ? ui.TextDirection.rtl
                  : ui.TextDirection.ltr,
              widget.note.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.note.body,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              child: Text(
                widget.note.createdAt.isToday()
                    ? DateFormat.jmz(isEnglish ? null : 'ar').format(widget.note.createdAt)
                    : DateFormat.yMMMd(isEnglish ? null : 'ar').format(widget.note.createdAt),
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.black38,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
