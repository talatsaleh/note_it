import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:notes_app/utils/localization/app_localization.dart';
import 'package:notes_app/utils/localization/detect_language.dart';
import 'package:notes_app/widgets/add_image_widget.dart';
import 'package:notes_app/widgets/colors_widget.dart';

import '../modules/note_module.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>
    with TickerProviderStateMixin {
  final _validate = StreamController.broadcast();
  bool isTitle = false;
  bool isDesc = false;
  bool isValid = false;
  final _titleFormKey = GlobalKey<FormFieldState>();
  final _descFormKey = GlobalKey<FormFieldState>();
  late FocusNode _focusNode;

  Animation<Color?> get _animation {
    return ColorTween(
            begin: _oldColor.withOpacity(.3),
            end: _selectedColor?.withOpacity(.3))
        .animate(_controller)
      ..addListener(
        () {
          setState(() {});
        },
      );
  }

  late AnimationController _controller;
  late AnimationController _controller2;
  String? _title;
  String? _desc;
  Color _oldColor = Colors.white12;
  Color? _selectedColor;
  File? _image;
  File? _newImage;
  Size? _size;

  @override
  void initState() {
    super.initState();
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 250));

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _validate.close();
    _focusNode.dispose();
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _saveForm() {
    _titleFormKey.currentState!.save();
    _descFormKey.currentState!.save();
    final created = DateTime.now();
    Navigator.of(context).pop(Note(
      id: created.microsecondsSinceEpoch.toString(),
      title: _title!,
      body: _desc!,
      createdAt: created,
      color: _selectedColor,
      image: _image,
    ));
  }



  @override
  Widget build(BuildContext context) {
    Locale appLocale = Localizations.localeOf(context);
    _size = MediaQuery.of(context).size;
    _validate.stream.listen((event) {
      if (event) {
        setState(() {
          isValid = true;
        });
      } else {
        setState(() {
          isValid = false;
        });
      }
    });
    return Stack(
      children: [
        if (_image != null)
          FadeTransition(
            opacity: _controller2,
            child: Image.file(_image!,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover),
          ),
        Container(
          width: _size!.width,
          height: _size!.height,
          color: Theme.of(context)
              .colorScheme
              .background
              .withOpacity(_image == null ? 1 : .85),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: (isTitle && isDesc) ? _saveForm : null,
                icon: const Icon(
                  Icons.done,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'title'.tr(context),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      textDirection: textDirection(appLocale, _title),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      onSaved: (value) {
                        _title = value;
                      },
                      onEditingComplete: () {
                        _focusNode.requestFocus();
                      },
                      key: _titleFormKey,
                      onChanged: (value) {
                        _title = value;
                        isTitle = _titleFormKey.currentState!.validate();
                        _validate.sink.add(isDesc && isTitle);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "valid_title".tr(context);
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _animation.value,
                        hintText: "title_".tr(context),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "description".tr(context),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      textDirection: textDirection(appLocale, _desc),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      onSaved: (value) {
                        _desc = value;
                      },
                      focusNode: _focusNode,
                      key: _descFormKey,
                      onChanged: (value) {
                        _desc = value;
                        isDesc = _descFormKey.currentState?.validate() ?? false;
                        _validate.sink.add(isDesc && isTitle);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "valid_description".tr(context);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _animation.value,
                        hintText: "task_description".tr(context),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: ColorsWidget(
                              saveColor: (color) {
                                setState(() {
                                  _controller.reset();
                                  _oldColor = _selectedColor ?? Colors.white;
                                  _selectedColor = color ?? Colors.white;
                                  _controller.forward();
                                });
                              },
                            ),
                          ),
                          const VerticalDivider(
                              color: Colors.white24,
                              thickness: 1.0,
                              indent: 3,
                              endIndent: 3,
                              width: 20),
                          AddImageWidget(
                            image: (image) {
                              setState(() {
                                _newImage = image;
                                if (_newImage == null) {
                                  _controller2
                                      .reverse()
                                      .then((value) => _image = _newImage);
                                } else {
                                  _image = _newImage;
                                  _controller2.forward();
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
