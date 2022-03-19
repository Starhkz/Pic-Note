import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

class NoteTile extends StatefulWidget {
  final Note note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  _NoteTileState createState() => _NoteTileState();
}

bool triggered = false;

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    Note note = widget.note;
    String subtitle = '';
    Date date = Date.toDate(note.date);
    if (note.subtitle != null && note.subtitle != 'null') {
      String encodedData = note.subtitle.toString();
      List<NoteMedia> noteMedia = NoteMedia.decode(encodedData);
      subtitle = noteMedia[0].note.toString();
    }

    return GestureDetector(
        onTap: () => {
              log(
                'Tapped ${note.id}',
                name: 'List Tile',
              ),
              setState(() {
                triggered = false;
              }),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditScreen(
                            note: note,
                            id: note.id,
                            isNew: false,
                          )))
            },
        onLongPress: () {
          log(
            'Long Pressed ${note.id}',
            name: 'List Tile',
          );
          setState(() {
            triggered = !triggered;
          });
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF242424)),
          onEnd: () {
            setState(() {
              if (triggered) {
                //canRun = true;
              }
            });
          },
          duration: const Duration(milliseconds: 300),
          height: triggered ? 118 : 88,
          alignment:
              triggered ? Alignment.center : AlignmentDirectional.topCenter,
          curve: Curves.fastOutSlowIn,
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
                        overflow: TextOverflow.ellipsis,
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
                        subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(note.id.toString(),
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
                  popDialog(context);
                  log(
                    'Tapped image Area of ${widget.note.id}',
                    name: 'Tile',
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.79 * 0.2,
                    height: MediaQuery.of(context).size.width * 0.79 * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
