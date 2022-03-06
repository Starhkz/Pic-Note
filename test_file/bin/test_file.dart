import 'note_model.dart';

void main(List<String> arguments) {
  Note trial =
      Note(id: 1, title: 'titlesss', date: 'date', subtitle: 'subtitle');

  List<Note> test = [trial, trial, trial, trial];
  String a = test.toString();

  print(a);
}
