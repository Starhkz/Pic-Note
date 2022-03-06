import 'dart:io';

import 'package:flutter/material.dart';

import '../imports.dart';

class Utils {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? pickedFileList;
  void logger(String name, String message) {
    return log(
      message,
      name: name,
    );
  }

  Future<List<XFile>?> getImage(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(
      source: source,
      // maxWidth: maxWidth,
      // maxHeight: maxHeight,
      // imageQuality: quality,
    );
    if (pickedFile != null) {
      logger('Picked File Nullity', pickedFile.name);
      pickedFileList = [pickedFile];
      return pickedFileList;
    } else {
      logger('Picked File Nullity', 'No data');
      return [];
    }
  }

  Future<List<XFile>?> getImages(ImageSource source) async {
    try {
      pickedFileList = await _picker.pickMultiImage(
          // maxWidth: maxWidth,
          // maxHeight: maxHeight,
          // imageQuality: quality,
          );
      return pickedFileList;
    } catch (e) {
      logger('Multi Image Picker Get List', e.toString());
    }
  }
}

previewImages(List<XFile>? pickedFiles) {
  print('I opened Utils');
  if (pickedFiles != null) {
    if (pickedFiles.isNotEmpty) {
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              // Why network for web?
              // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: Image.file(File(pickedFiles[index].path)),
              );
            },
            itemCount: pickedFiles.length,
          ),
          label: 'Note Label');
    } else if (pickedFiles.isEmpty) {
      return const Text(
        'Pick image error: ',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      );
    }
  } else {
    return const Text(
      'You have not yet picked an image.',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    );
  }
}
