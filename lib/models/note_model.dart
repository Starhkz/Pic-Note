import 'dart:convert';

import 'package:pic_note/imports.dart';
import 'package:pic_note/shared/string_list.dart';

class Note {
  final int id;
  final String title;
  final String? subtitle;
  final DateTime date;
  final String? imageUrl;
  final List<String>? tags;
  Note(
      {this.imageUrl,
      this.tags,
      required this.id,
      required this.title,
      required this.date,
      required this.subtitle});
  Map<String, dynamic> toMap() {
    return {
      cId: id,
      cTitle: title,
      cSubtitle: subtitle,
      cDate: date.toString(),
      cImageURL: imageUrl,
      cTag: Liststring.encode(tags)
    };
  }

  factory Note.fromJson(Map<dynamic, dynamic> json) {
    return Note(
        id: json[cId],
        title: json[cTitle],
        date: DateTime.tryParse(json[cDate]) ?? DateTime.now(),
        subtitle: json[cSubtitle],
        imageUrl: json[cImageURL],
        tags: Liststring.decode(json[cTag]));
  }
  // Implement toString to make it easier to see information about
  // each note when using the print statement.
  @override
  String toString() {
    return '$picNote{$cId: $id, $cTitle: $title, $cSubtitle: $subtitle, $cDate: $date, $cImageURL: $imageUrl, $cTag: ${Liststring.encode(tags!)}}';
  }
}

List<Note> mapToNote(List<Map<String, dynamic>> maps) {
  List<Note>? notes = [];
  for (var element in maps) {
    notes.add(Note.fromJson(element));
  }
  return notes;
}

///Note file with media
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

  /// Returns NoteMedia from a [json]
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

  /// Encodes the List of [NoteMedia] to a [String] that can be saved
  /// to the SQLite Database
  static String encode(List<NoteMedia> noteMedia) => json.encode(
        noteMedia
            .map<Map<String, dynamic>>((noteMedia) => noteMedia.toMap())
            .toList(),
      );

  /// Decodes Encoded [NoteMedia] List [String] and returns a List of [NoteMedia]
  /// Can only decode String encoded with [NoteMedia.encode]
  static List<NoteMedia> decode(String noteMediaList) =>
      (json.decode(noteMediaList) as List<dynamic>)
          .map<NoteMedia>((item) => NoteMedia.fromJson(item))
          .toList();
}
