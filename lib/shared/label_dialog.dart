import 'package:flutter/material.dart';
import 'package:pic_note/imports.dart';

labelDialog(BuildContext context, Note note, int index) async {
  PicDataBase picDataBase = Provider.of<PicDataBase>(context, listen: false);
  List<String> tags = [];
  tags = await picDataBase.getTags(index);
  String tag = '';
  TextEditingController textEditingController = TextEditingController();
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        /// Updates an existing [Note]

        return AlertDialog(
          title: const Center(
              child: Text(
            cUpdateLabel,
          )),
          content: SizedBox(
            height: 160,
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LabelRow(picDataBase: picDataBase, index: index, note: note),
                  TextFormField(
                    cursorColor: Theme.of(context).textTheme.headline1!.color,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        counterStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color)),
                    maxLength: 15,
                    onChanged: (value) {
                      tag = value;
                    },
                    controller: textEditingController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          textEditingController.clear();
                          Navigator.pop(context, cCamera);
                        },
                        child: const Text(cCancel),
                      ),
                      TextButton(
                        autofocus: tag.trim().isNotEmpty,
                        onPressed: () {
                          if (tag.trim().isNotEmpty && tags.length < 6) {
                            tags.add(tag);
                            Note newNote = Note(
                                id: note.id,
                                title: note.title.toString(),
                                date: DateTime.now(),
                                subtitle: note.subtitle,
                                tags: tags);
                            Utils().update(newNote, picDataBase);
                            tag = '';
                            textEditingController.clear();
                            setState(() {});
                            Utils().logger(
                                cHome, 'Tag list is ${tags.toString()}');
                          } else {
                            Utils().logger(cAlertDialog, cNullValue);
                          }
                          textEditingController.clear();
                        },
                        child: const Text(cAdd),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
