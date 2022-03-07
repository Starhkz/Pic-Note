import 'dart:convert';

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

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Encode and store data in SharedPreferences
  final String encodedData = Music.encode([
    // Music(id: 1, ...),
    // Music(id: 2, ...),
    // Music(id: 3, ...),
  ]);

  await prefs.setString('musics_key', encodedData);

  // Fetch and decode data
  //final String musicsString = await prefs.getString('musics_key');

  //final List<Music> musics = Music.decode(musicsString);
}

class Music {
  final int? id;
  final String? name, size, rating, duration, img;
  bool? favorite;

  Music({
    this.id,
    this.rating,
    this.size,
    this.duration,
    this.name,
    this.img,
    this.favorite,
  });

  factory Music.fromJson(Map<String, dynamic> jsonData) {
    return Music(
      id: jsonData['id'],
      rating: jsonData['rating'],
      size: jsonData['size'],
      duration: jsonData['duration'],
      name: jsonData['name'],
      img: jsonData['img'],
      favorite: false,
    );
  }

  static Map<String, dynamic> toMap(Music music) => {
        'id': music.id,
        'rating': music.rating,
        'size': music.size,
        'duration': music.duration,
        'name': music.name,
        'img': music.img,
        'favorite': music.favorite,
      };

  static String encode(List<Music> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Music.toMap(music))
            .toList(),
      );

  static List<Music> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Music>((item) => Music.fromJson(item))
          .toList();
}
