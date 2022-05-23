import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

import '../shared/styling/colors.dart';

class LabelRow extends StatefulWidget {
  const LabelRow({
    Key? key,
    required this.picDataBase,
    required this.index,
    required this.note,
  }) : super(key: key);

  final PicDataBase picDataBase;
  final int index;
  final Note note;

  @override
  State<LabelRow> createState() => _LabelRowState();
}

class _LabelRowState extends State<LabelRow> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.picDataBase.getTags(widget.index),
      builder: (context, snapshot) {
        List<String> tags = [];
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          tags = snapshot.data!;
          return Center(
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: false,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                key: UniqueKey(),
                itemBuilder: (BuildContext context, int ind) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(7, 5, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context)
                                .floatingActionButtonTheme
                                .backgroundColor),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Text(
                                tags[ind],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 25,
                                  splashColor:
                                      const Color.fromARGB(68, 25, 56, 212),
                                  onPressed: () {
                                    popLabel(ind, tags);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 15,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: tags.length,
              ),
            ),
          );
        } else {
          return Bubble(
            width: 100,
            height: 40,
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: const Text(
              cAddLabel,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          );
        }
      },
    );
  }

  popLabel(
    int pos,
    List<String> tags,
  ) {
    tags.removeAt(pos);
    Note newNote = Note(
        id: widget.note.id,
        title: widget.note.title.toString(),
        date: DateTime.now(),
        subtitle: widget.note.subtitle,
        tags: tags);
    Utils().update(newNote, widget.picDataBase);
    setState(() {});
  }
}
