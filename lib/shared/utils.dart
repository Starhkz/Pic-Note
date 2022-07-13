import 'dart:io';

import 'package:flutter/material.dart';

import '../imports.dart';

/// Contains tools required to run the app
class Utils {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? pickedFileList;

  /// Writes logs to the console for debugging
  void logger(String name, String message) {
    return log(
      message,
      name: name,
    );
  }

  /// Used to pick a single image from the chosen image source
  Future<List<XFile>?> getImage(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(
      source: source,
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

  /// Used to select multiple images from gallery
  Future<List<XFile>?> getImages(ImageSource source) async {
    try {
      pickedFileList = await _picker.pickMultiImage();
      return pickedFileList;
    } catch (e) {
      logger('Multi Image Picker Get List', e.toString());
      return [];
    }
  }

  /// Updates the note with the new data
  void update(Note newNote, PicDataBase picDataBase) async {
    await picDataBase.editNote(newNote);
  }
}

/// Returns the [Image] widget if available
previewImages(List<XFile>? pickedFiles) {
  if (pickedFiles != null) {
    if (pickedFiles.isNotEmpty) {
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
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
      );
    }
  } else {
    return const Text(
      'You have not yet picked an image.',
      textAlign: TextAlign.center,
    );
  }
}

/// Date class
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

  /// Converts [DateTime] object to a [Date] class
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

    /// Reformats the number by adding a zero if it's a unit
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

class SearchBar extends SearchDelegate<Note> {
  bool canExpand = false;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  final List<Note> notes;
  SearchBar({
    required this.notes,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => {query = ''}, icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => {
              close(context, notes[0]),
            },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: notes
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()) ||
              element.subtitle
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .map((element) => NoteTile(
                note: element,
                canExpand: canExpand,
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: notes
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()) ||
              element.subtitle
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .map((element) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () => {
                    log(
                      'Tapped ${element.id}',
                      name: 'List Tile',
                    ),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditScreen(
                                  note: element,
                                  id: element.id,
                                  isNew: false,
                                )))
                  },
                  child: NoteTile(
                    note: element,
                    canExpand: canExpand,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

Future<dynamic> exitPrompt(BuildContext context, void Function() save,
    {AnimationController? controller, bool isTab = false}) async {
  navHome(BuildContext context) {
    if (isTab) {
      controller?.reverse();
    } else {
      return Navigator.pop(context);
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          cExitConfirmation,
          style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  cSave,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                ),
                onPressed: () {
                  save();
                  // ShrinkAll().shrinkAllToggle();
                  navHome(context);
                },
              ),
              TextButton(
                child: Text(
                  cDiscard,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                ),
                onPressed: () {
                  //Discard
                  Utils().logger(cEditNote, cDiscButtonTapped);
                  // ShrinkAll().shrinkAllToggle();
                  navHome(context);
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
