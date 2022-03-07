import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'imports.dart';

class EditScreen extends StatefulWidget {
  final int id;
  final bool isNew;

  final Note? note;
  const EditScreen({
    Key? key,
    required this.id,
    required this.isNew,
    this.note,
  }) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  int id = 0;
  List<XFile>? imageFile;
  bool isLoaded = false;
  List<NoteMedia> noteGallery = [];
  @override
  void initState() {
    super.initState();
    initStore();
    if (!widget.isNew) extractNoteMedia();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isNew = widget.isNew;
    String? _title, _note;
    Note? note;
    if (!isNew) {
      note = widget.note!;
      _title = note.title;
      _note = note.subtitle;
    }
    void addTab(NoteMedia newNoteMedia) async {
      noteGallery.add(newNoteMedia);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          {
            Utils().logger("Edit Screen", cCameraLog);
            imageFile = await popDialog(context);
            setState(() {
              isLoaded = true;
            });
          }
        },
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () => {navHome(context)},
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.blue,
          ),
        ),
        title: Text(
          isNew ? cNewNote : cEditNote,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              onTap: () {
                Utils().logger(cEditNote, cCameraLog);
                _formKey.currentState!.save();
                if (isNew) {
                  Note newNote = Note(
                      id: id,
                      title: _title.toString(),
                      date: DateTime.now().day.toString(),
                      subtitle: NoteMedia.encode(noteGallery));
                  addNote(newNote);
                } else {
                  Utils().logger('Edit Screen', 'Updated ${widget.id}');
                  Note newNote = Note(
                      id: note!.id,
                      title: _title.toString(),
                      date: DateTime.now().day.toString(),
                      subtitle: NoteMedia.encode(noteGallery));
                  update(newNote);
                }

                navHome(context);
              },
              child: Icon(
                isNew ? Icons.check : Icons.update,
                color: Colors.blue,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                  child: Text(
                    cDummyDate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () async {
                          imageFile = await popDialog(context);

                          int nMID = noteGallery.length;
                          NoteMedia newNoteMedia = NoteMedia(
                              id: nMID,
                              isMedia: true,
                              imageUrl: imageFile![0].path,
                              note: 'Same thing');

                          addTab(newNoteMedia);
                          setState(() {
                            isLoaded = true;
                          });
                          Utils().logger(cEditNote, 'Tapped Add Image $nMID');
                        },
                        child: const Text(
                          'Add Image',
                          style: TextStyle(color: Colors.blue),
                        )),
                    TextButton(
                        onPressed: () {
                          int nMID = noteGallery.length;
                          NoteMedia newNoteMedia = NoteMedia(
                              id: nMID,
                              isMedia: false,
                              imageUrl: 'Empty',
                              note: 'Same thing');

                          addTab(newNoteMedia);
                          Utils().logger(cEditNote, 'Tapped Add Note $nMID');
                        },
                        child: const Text(
                          'Add Note',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        noteGallery.last.note = 'It changed to a note';
                        Utils().logger(cEditNote, noteGallery.toString());
                      },
                      child: const Text(
                        'Log Note',
                        style: TextStyle(color: Colors.grey),
                      )),
                ),
                SizedBox(
                  height: 25,
                  child: TextFormField(
                    initialValue: _title,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white60,
                        fontSize: 20,
                      ),
                      hintText: cTitle,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                    onChanged: (value) {
                      _title = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textMethod(noteGallery),
                isLoaded
                    ? SizedBox(height: 550, child: previewImages(imageFile))
                    : const Text(
                        'Nothing Yet',
                        style: TextStyle(color: Colors.white),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textMethod(List<NoteMedia> noteMedia) {
    return SizedBox(
      height: 700,
      child: ListView.builder(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          // Why network for web?
          // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
          return Semantics(
              label: 'image_picker_example_picked_image',
              child: tile(noteMedia[index], index));
        },
        itemCount: noteMedia.length,
      ),
    );
  }

  void navHome(BuildContext context) {
    return Navigator.pop(
        context, MaterialPageRoute(builder: (_) => const Home()));
  }

  void addNote(Note newNote) async {
    await PicDataBase().insertNote(newNote);
  }

  void initStore() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt(cCurrentID)!;
  }

  void extractNoteMedia() {
    Note? note = widget.note;
    String encodedList = note!.subtitle;
    noteGallery = NoteMedia.decode(encodedList);
  }

  tile(NoteMedia noteMedia, int index) {
    if (noteMedia.isMedia) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: Image.file(File(noteMedia.imageUrl.toString())),
      );
    } else {
      return SizedBox(
        child: TextFormField(
          initialValue: noteMedia.note,
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintStyle: TextStyle(
              color: Colors.white38,
              fontSize: 17,
            ),
            hintText: cDummyHint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          ),
          onChanged: (value) {
            noteGallery[index].note = value;
          },
        ),
      );
    }
  }
}

void update(Note newNote) async {
  await PicDataBase().editNote(newNote);
}

Future<List<XFile>?>? popDialog(context) async {
  Future<List<XFile>?>? imageFiles;
  await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Upload Photo'),
      content: const Text('Photo'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            imageFiles = Utils().getImage(ImageSource.camera);
            Navigator.pop(context, 'Camera');
          },
          child: const Text('Camera'),
        ),
        TextButton(
          onPressed: () {
            imageFiles = Utils().getImages(ImageSource.gallery);

            Navigator.pop(context, 'Gallery');
          },
          child: const Text('Gallery'),
        ),
      ],
    ),
  );
  return imageFiles;
}
