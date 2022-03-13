import 'dart:convert';

import 'package:pic_note/imports.dart';

class Note {
  final int id;
  final String title;
  final String? subtitle;
  final DateTime date;
  Note(
      {required this.id,
      required this.title,
      required this.date,
      required this.subtitle});
  Map<String, dynamic> toMap() {
    return {
      cId: id,
      cTitle: title,
      cSubtitle: subtitle,
      cDate: date.toString()
    };
  }

  factory Note.fromJson(Map<dynamic, dynamic> json) {
    return Note(
        id: json[cId],
        title: json[cTitle],
        date: DateTime.tryParse(json[cDate]) ?? DateTime.now(),
        subtitle: json[cSubtitle]);
  }
  // Implement toString to make it easier to see information about
  // each note when using the print statement.
  @override
  String toString() {
    return '$picNote{$cId: $id, $cTitle: $title, $cSubtitle: $subtitle, $cDate: $date}';
  }
}

List<Note> mapToNote(List<Map<String, dynamic>> maps) {
  List<Note> notes = [];
  var test = maps.toString();
  Utils().logger('Note Model', test);
  for (var element in maps) {
    notes.add(Note.fromJson(element));
  }
  return notes;
}

//Note file with media
class NoteMedia {
  final int id;
  final bool isMedia;
  String? note;
  final String? imageUrl;
  NoteMedia(
      {required this.id, required this.isMedia, this.note, this.imageUrl});
  Map<String, dynamic> toMap() {
    return {cId: id, cIsMedia: isMedia, cNote: note, cImageURL: imageUrl};
  }

  factory NoteMedia.fromJson(Map<dynamic, dynamic> json) {
    return NoteMedia(
        id: json[cId],
        isMedia: json[cIsMedia],
        note: json[cNote],
        imageUrl: json[cImageURL]);
  }
  // Implement toString to make it easier to see information about
  // each note when using the print statement.
  @override
  String toString() {
    return '{$cId: $id, $cIsMedia: $isMedia, $cNote: $note, $cImageURL: $imageUrl}';
  }

  static String encode(List<NoteMedia> noteMedia) => json.encode(
        noteMedia
            .map<Map<String, dynamic>>((noteMedia) => noteMedia.toMap())
            .toList(),
      );

  static List<NoteMedia> decode(String noteMediaList) =>
      (json.decode(noteMediaList) as List<dynamic>)
          .map<NoteMedia>((item) => NoteMedia.fromJson(item))
          .toList();
}

List<NoteMedia> mapToNoteMedia(List<Map<String, dynamic>> maps) {
  List<NoteMedia> notes = [];
  var test = maps.toString();
  Utils().logger('Note Model', test);
  for (var element in maps) {
    notes.add(NoteMedia.fromJson(element));
  }
  return notes;
}
