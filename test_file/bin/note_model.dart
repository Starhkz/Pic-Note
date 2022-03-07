import 'dart:convert';

import 'constants.dart';

class Note {
  final int id;
  final String title;
  final String subtitle;
  final String date;
  Note(
      {required this.id,
      required this.title,
      required this.date,
      required this.subtitle});
  Map<String, dynamic> toMap() {
    return {cId: id, cTitle: title, cSubtitle: subtitle, cDate: date};
  }

  factory Note.fromJson(Map<dynamic, dynamic> json) {
    return Note(
        id: json[cId],
        title: json[cTitle],
        date: json[cDate],
        subtitle: json[cSubtitle]);
  }
  // Implement toString to make it easier to see information about
  // each note when using the print statement.
  @override
  String toString() {
    return '{$cId: $id, $cTitle: $title, $cSubtitle: $subtitle, $cDate: $date}';
  }
}

List<Note> mapToNote(List<Map<String, dynamic>> maps) {
  List<Note> notes = [];
  var test = notes.toString();
  for (var element in maps) {
    notes.add(Note.fromJson(element));
  }
  return notes;
}

//Note file with media
class NoteMedia {
  final int id;
  final bool isMedia;
  final String? note;
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
    return '$picNoteMedia{$cId: $id, $cIsMedia: $isMedia, $cNote: $note, $imageUrl: $cImageURL}';
  }

  String encode(List<NoteMedia> noteMedia) => json.encode(
        noteMedia
            .map<Map<String, dynamic>>((noteMedia) => noteMedia.toMap())
            .toList(),
      );

  List<NoteMedia> decode(String noteMedia) =>
      (json.decode(noteMedia) as List<dynamic>)
          .map<NoteMedia>((item) => NoteMedia.fromJson(item))
          .toList();
}
