import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/utils/localization/app_localization.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget({super.key, required this.image});

  final void Function(File?) image;

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  Size? size;
  late PickImage picker;

  @override
  void initState() {
    picker = PickImage(context, pickImage: (image) {
      widget.image(image);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Widget content = IconButton(
      icon: const Icon(Icons.add_photo_alternate_outlined),
      style: IconButton.styleFrom(
          fixedSize: Size(size!.width * .18, size!.width * .18),
          backgroundColor: Colors.white12),
      onPressed: () {
        picker.addImage();
      },
    );
    if (picker.prevImage) {
      content = IconButton(
        icon: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.error.withOpacity(.7),
        ),
        style: IconButton.styleFrom(
            fixedSize: Size(size!.width * .18, size!.width * .18),
            backgroundColor: Colors.white12),
        onPressed: picker.removeImage,
      );
    }

    return content;
  }
}

class CustomVerticalIconButton extends StatelessWidget {
  const CustomVerticalIconButton(
      {super.key,
      this.size,
      required this.icon,
      required this.label,
      required this.action});

  final double? size;
  final IconData icon;
  final String label;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white12, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: size == null ? null : size! * .5, color: Colors.white60),
            FittedBox(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white60),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PickImage {
  PickImage(this.context,
      {this.image, required this.pickImage, this.isSet = false});

  File? image;
  final void Function(File? image) pickImage;
  final bool isSet;
  final BuildContext context;
  bool prevImage = false;

  Size get size {
    return MediaQuery.of(context).size;
  }

  void removeImage() {
    prevImage = false;
    image = null;
    pickImage(image);
  }

  void _pickImage(ImageSource mode) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: mode);
    if (pickedImage == null) {
      return;
    }
    image = File(pickedImage.path);
    pickImage(image);
    prevImage = true;
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void addImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: size.height * .2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomVerticalIconButton(
                size: image != null && isSet ? null : size.height * .15,
                label: "take_photo".tr(context),
                icon: Icons.add_a_photo_outlined,
                action: () => _pickImage(ImageSource.camera),
              ),
              CustomVerticalIconButton(
                action: () => _pickImage(ImageSource.gallery),
                size: image != null && isSet ? null : size.height * .15,
                icon: Icons.add_photo_alternate_outlined,
                label: "from_Gallery".tr(context),
              ),
              if (image != null && isSet)
                CustomVerticalIconButton(
                    size: null,
                    icon: Icons.close,
                    label: "remove".tr(context),
                    action: () {
                      removeImage();
                      prevImage = false;
                      Navigator.of(context).pop();
                    })
            ],
          ),
        );
      },
    );
  }
}
