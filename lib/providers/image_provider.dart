import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as app_path;
import 'package:path/path.dart' as path;

class ImageNotifier extends StateNotifier<File?> {
  ImageNotifier() : super(null);

  Future<Directory> _getPath() async {
    final appDir = await app_path.getApplicationDocumentsDirectory();
    Directory appDocImageFolder = Directory('${appDir.path}/background/');
    if (!appDocImageFolder.existsSync()) {
      appDocImageFolder = await appDocImageFolder.create(recursive: true);
    }
    return appDocImageFolder;
  }

  void getImage() async {
    final Directory appDocImageFolder = await _getPath();
    final list = appDocImageFolder.listSync(recursive: true);
    if (list.isEmpty) {
      print('there is no image!');
      return null;
    }
    state = list.first as File?;
  }

  void setImage(File? image) async {
    _removeImage();
    final Directory appDocImageFolder = await _getPath();
    if (image == null) {
      return;
    }
    state = await _copyImage(image, appDocImageFolder);
  }

  Future<File> _copyImage(File image, Directory appDocImageFolder) async {
    final imageName = path.basename(image.path);
    print('${appDocImageFolder.path}$imageName');
    return image.copy('${appDocImageFolder.path}$imageName');
  }

  void _removeImage() async {
    final image = state;
    if (state == null) {
      return;
    }
    await image!.delete();
    state = null;
  }
}

final imageProvider =
    StateNotifierProvider<ImageNotifier, File?>((ref) => ImageNotifier());
