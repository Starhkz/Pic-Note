import 'note_model.dart';

void main(List<String> arguments) {
  String test = '[What is your name?]';
  int len = test.length;
  String a = test.substring(1, len - 1);

  print(a);
}
