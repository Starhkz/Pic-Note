// Create Data repository
// Source: screen_data.dart

import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

class ScreenData {
  final Note? note;
  final bool isNewNote;
  const ScreenData({
    this.note,
    required this.isNewNote,
  });
}

class ScreenDataNotifier extends ChangeNotifier {
  static ScreenData? _screenData;

  ScreenData? get screenData => _screenData;

  set screenData(ScreenData? screenData) {
    _screenData = screenData;
    notifyListeners();
  }
}
