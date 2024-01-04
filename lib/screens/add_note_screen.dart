import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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
    print(isTitle && isDesc);
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
                          'Title',
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      onSaved: (value) {
                        _title = value;
                      },
                      onEditingComplete: () {
                        _focusNode.requestFocus();
                      },
                      key: _titleFormKey,
                      onChanged: (_) {
                        isTitle = _titleFormKey.currentState!.validate();
                        _validate.sink.add(isDesc && isTitle);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please add valid title..';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _animation.value,
                        hintText: 'Title..',
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
                        'Description',
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      onSaved: (value) {
                        _desc = value;
                      },
                      focusNode: _focusNode,
                      key: _descFormKey,
                      onChanged: (_) {
                        isDesc = _descFormKey.currentState?.validate() ?? false;
                        _validate.sink.add(isDesc && isTitle);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please add valid description';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _animation.value,
                        hintText: 'Enter task description.',
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
                                  print(color);
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
                                if(_newImage == null){
                                  _controller2.reverse().then((value) => _image = _newImage);
                                }else{
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
