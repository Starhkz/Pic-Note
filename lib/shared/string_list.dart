import 'dart:convert';

import 'package:pic_note/imports.dart';

extension Liststring on List {
  static String? encode(List<String>? listString) {
    if (listString != null) {
      return json.encode(
        listString
            .map<Map<String, String>>((string) => string.toMap(string))
            .toList(),
      );
    } else {
      return null;
    }
  }

  /// Decodes Encoded [String] List [String] and returns a List of [String]
  /// Can only decode String encoded with [Liststring.encode]
  static List<String> decode(String? stringList) {
    if (stringList != null && stringList != '') {
      return (json.decode(stringList) as List<dynamic>)
          .map<String>((string) => PicString.fromJson(string))
          .toList();
    } else {
      return [];
    }
  }
}

extension PicString on String {
  Map<String, String> toMap(String text) {
    return {cText: text};
  }

  static String fromJson(Map<dynamic, dynamic> json) {
    return json[cText] ?? '';
  }
}
