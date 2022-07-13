import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

class NoteTile extends StatefulWidget {
  final Note note;
  final bool canExpand;
  const NoteTile({Key? key, required this.note, required this.canExpand})
      : super(key: key);

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
  bool triggered = false;
  bool canDisplay = false;
  @override
  Widget build(BuildContext context) {
    PicDataBase picDataBase = Provider.of<PicDataBase>(context, listen: false);

    NoteMedia? image;
    bool containsImage = false;
    String imageUrl = '';
    Note note = widget.note;
    List<NoteMedia>? noteGallery;
    if (note.subtitle != null && note.subtitle != 'null') {
      String encodedList = note.subtitle.toString();
      try {
        noteGallery = NoteMedia.decode(encodedList);
        containsImage = noteGallery.any((element) => element.isMedia);
      } catch (e) {
        containsImage = false;
      }
    }
    if (containsImage) {
      image = noteGallery!.firstWhere((element) => element.isMedia);
      imageUrl = image.imageUrl.toString();
    }
    String subtitle = '';
    Date date = Date.toDate(note.date);
    if (note.subtitle != null && note.subtitle != 'null') {
      String encodedData = note.subtitle.toString();
      try {
        List<NoteMedia> noteMedia = NoteMedia.decode(encodedData);
        subtitle = noteMedia[0].note.toString();
      } catch (e) {
        subtitle = 'Error';
      }
    }

    return Center(
      child: GestureDetector(
          onLongPress: () {
            log(
              'Long Pressed ${note.id}',
              name: 'List Tile',
            );
            setState(() {
              if (!triggered && widget.canExpand) {
                triggered = true;
              } else {
                canDisplay = false;
                triggered = false;
              }

              // if (!triggered) {
              //   _controller.forward();
              // } else {
              //   _controller.reverse();
              // }
            });
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColor),
                  onEnd: () {
                    setState(() {
                      if (triggered) {
                        canDisplay = true;
                      }
                    });
                  },
                  duration: const Duration(milliseconds: 200),
                  height: triggered ? 150 : 88,
                  alignment: triggered
                      ? Alignment.center
                      : AlignmentDirectional.center,
                  curve: Curves.fastOutSlowIn,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.79 *
                                  0.8 *
                                  0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.note.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // ignore: prefer_const_constructors
                                  Text(
                                    subtitle,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    date.dateTime,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  )
                                ],
                              ),
                            ),
                          ),
                          containsImage
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              content: Image.file(
                                                File(imageUrl),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.79 *
                                                    0.8,
                                              ));
                                        });
                                    log(
                                      'Tapped image Area of ${widget.note.id}',
                                      name: 'Tile',
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue,
                                          image: DecorationImage(
                                            image: FileImage(File(imageUrl)),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      if (triggered && canDisplay)
                        LabelRow(
                          picDataBase: picDataBase,
                          index: note.id,
                          note: note,
                          canClick: true,
                        )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
