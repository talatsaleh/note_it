import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/providers/image_provider.dart';
import 'package:notes_app/widgets/add_image_widget.dart';
import 'package:path/path.dart' as path;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenNotifier();
}

class _SettingsScreenNotifier extends ConsumerState<SettingsScreen> {
  late PickImage picker;
  File? _image;
  bool _isRun = true;

  @override
  void didChangeDependencies() {
    if (_isRun) {
      picker = PickImage(
        context,
        pickImage: (image) {
          setState(() {
            ref.read(imageProvider.notifier).setImage(image);
            _isRun = false;
          });
        },
        isSet: true,
      );
      _isRun = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _image = ref.watch(imageProvider);
    picker.image = _image;
    return Stack(
      children: [
        if (_image != null)
          Image.file(
            _image!,
            fit: BoxFit.cover,
            height: double.infinity,
          ),
        Scaffold(
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(.8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Settings'),
          ),
          body: Column(
            children: [
              ListTile(
                onTap: () {
                  picker.addImage();
                },
                leading: const Icon(Icons.add_photo_alternate_outlined),
                title: const Text('Add Background'),
                trailing:
                    _image == null ? null : Text(path.basename(_image!.path)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
