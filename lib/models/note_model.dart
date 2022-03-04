import 'package:pic_note/imports.dart';

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
    return '$picNote{$cId: $id, $cTitle: $title, $cSubtitle: $subtitle, $cDate: $date}';
  }
}

List<Note> mapToNote(List<Map<String, dynamic>> maps) {
  List<Note> notes = [];
  for (var element in maps) {
    notes.add(Note.fromJson(element));
  }
  return notes;
}
