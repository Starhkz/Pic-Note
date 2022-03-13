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

class Date {
  final String date;
  final String month;
  final int day;
  final int year;
  final int hour;
  final int minute;
  final String period;
  final String time;
  final String dateTime;

  Date(this.date, this.month, this.day, this.year, this.hour, this.minute,
      this.period, this.time, this.dateTime);

  factory Date.toDate(DateTime dT) {
    final String date;
    final String month;
    final int day;
    final int year;
    int hour;
    final int minute;
    final String time;
    final String period;
    final String dateTime;

    String zeroFormat(int num) {
      if (num < 10) {
        return '0$num';
      }
      return num.toString();
    }

    List<String> months = [
      cJan,
      cFeb,
      cMar,
      cApr,
      cMay,
      cJan,
      cJul,
      cAug,
      cSep,
      cOct,
      cNov,
      cDec
    ];
    day = dT.day;
    month = months[dT.month - 1];
    year = dT.year;
    hour = dT.hour;
    minute = dT.minute;
    date = '$month ${zeroFormat(day)}, $year';

    if (hour < 12) {
      period = 'AM';
    } else {
      period = 'PM';
    }
    if (hour % 12 == 0) {
      hour = 12;
    } else {
      hour = hour % 12;
    }
    time = '${zeroFormat(hour)}:${zeroFormat(minute)} $period';
    dateTime = '$date $time';
    return Date(date, month, day, year, hour, minute, period, time, dateTime);
  }
}
