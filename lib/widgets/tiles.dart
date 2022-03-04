import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

class NoteTile extends StatefulWidget {
  final Note note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF242424)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.79 * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.note.title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // ignore: prefer_const_constructors
                  Text(
                    widget.note.subtitle,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.note.id.toString(),
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(
                    height: 7,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              popDialog();
              log(
                'Tapped image Area of ${widget.note.id}',
                name: 'Tile',
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.79 * 0.2,
                    height: MediaQuery.of(context).size.width * 0.79 * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

popDialog() {
  return AlertDialog(
    title: const Text('Welcome'), // To display the title it is optional
    content: const Text(
        'GeeksforGeeks'), // Message which will be pop up on the screen
    // Action widget which will provide the user to acknowledge the choice
    actions: [
      FlatButton(
        // FlatButton widget is used to make a text to work like a button
        textColor: Colors.black,
        onPressed: () {}, // function used to perform after pressing the button
        child: const Text('CANCEL'),
      ),
      FlatButton(
        textColor: Colors.black,
        onPressed: () {},
        child: const Text('ACCEPT'),
      ),
    ],
  );
}
