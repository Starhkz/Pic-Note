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
  bool canSave = true;
  List<XFile>? imageFile;
  List<NoteMedia>? noteGallery;
  @override
  void initState() {
    super.initState();
    initStore();

    if (!widget.isNew) extractNoteMedia();
  }

  final _formKey = GlobalKey<FormState>();

  bool firstBuild = true;
  @override
  Widget build(BuildContext context) {
    bool isNew = widget.isNew;
    String? _title;
    DateTime? date;
    Note? note;
    String? dateString;
    if (!isNew) {
      canSave = true;
      note = widget.note!;
      _title = note.title;
      date = note.date;
      dateString = Date.toDate(date).dateTime;
    } else if (firstBuild) {
      firstBuild = false;
      noteGallery ??= [];
      noteGallery!.add(NoteMedia(id: id, isMedia: false));
      Utils().logger('Edit Screen',
          'The list has  ${noteGallery!.length.toString()} element(s)');
    }
    dateString ??= Date.toDate(DateTime.now()).date;
    void addTab(NoteMedia newNoteMedia) async {
      noteGallery!.add(newNoteMedia);
    }

    final titleController = TextEditingController(text: _title);
    void addTextField() {
      int nMID = noteGallery!.length;
      NoteMedia newNoteMedia =
          NoteMedia(id: nMID, isMedia: false, imageUrl: null, note: '');

      addTab(newNoteMedia);
      Utils().logger(cEditNote, 'Added Text Field $nMID');
      setState(() {});
      Utils().logger('Text Field', canSave.toString());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          imageFile = await popDialog(context);

          int nMID = noteGallery!.length;
          if (imageFile != null) {
            NoteMedia newNoteMedia = NoteMedia(
                id: nMID,
                isMedia: true,
                imageUrl: imageFile![0].path,
                note: '');
            addTab(newNoteMedia);
          } else {
            return;
          }
          Utils().logger(
              cEditNote, 'Tapped Add Image ${noteGallery![nMID].imageUrl}');
          addTextField();
          _formKey.currentState!.save();
          setState(() {});
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
                if (noteGallery![0].note == 'null' ||
                    noteGallery![0].note == null ||
                    noteGallery![0].note == '') {
                  canSave = false;
                }
                Utils().logger(cEditNote, 'Saved Button was tapped');
                _formKey.currentState!.save();
                if (canSave) {
                  if (isNew) {
                    Note newNote = Note(
                        id: id,
                        title: titleController.text,
                        date: DateTime.now(),
                        subtitle: noteGallery != null
                            ? NoteMedia.encode(noteGallery!)
                            : null);
                    if (noteGallery == null) {
                      navHome(context);
                      return;
                    } else {
                      addNote(newNote);
                      Utils().logger('Edit Screen',
                          'Create: Save Test - ${newNote.subtitle}');
                    }
                  } else {
                    Utils().logger('Edit Screen', 'Updated ${widget.id}');
                    Note newNote = Note(
                        id: note!.id,
                        title: titleController.text,
                        date: DateTime.now(),
                        subtitle: NoteMedia.encode(noteGallery!),
                        tags: ['Tag ${note.id}']);
                    update(newNote);
                    Utils().logger('Edit Screen',
                        'Update: Save Test - ${newNote.subtitle}');
                  }
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  dateString,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 25,
                child: TextFormField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white60,
                      fontSize: 20,
                    ),
                    hintText: cCTitle,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                  onChanged: (value) {
                    Utils().logger('Edit Screen', value);
                    _title = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: noteWidget(noteGallery!, context),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the contents of the note
  noteWidget(List<NoteMedia> noteMedia, BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      key: UniqueKey(),
      itemBuilder: (BuildContext context, int index) {
        // Why network for web?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Semantics(
            label: 'image_picker_example_picked_image',
            child: tile(noteMedia[index], index));
      },
      itemCount: noteMedia.length,
    );
  }

  /// Returns you to the home screen from any point in the app
  navHome(BuildContext context) {
    return Navigator.pop(context);
  }

  /// Add note to the database
  void addNote(Note newNote) async {
    await PicDataBase().insertNote(newNote);
  }

  /// Updates an existing [Note]
  void update(Note newNote) async {
    await PicDataBase().editNote(newNote);
  }

  /// Retrieves the ID for the particular note
  void initStore() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt(cCurrentID)!;
  }

  /// Converts encoded string stored in the datatabase to a list of NoteMedia
  void extractNoteMedia() {
    Note? note = widget.note;
    if (note!.subtitle != null && note.subtitle != 'null') {
      String encodedList = note.subtitle.toString();
      noteGallery = NoteMedia.decode(encodedList);
    }
  }

  /// Returns A Notemedia tile. It could be a [TextFormField] or an [Image]
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
            Utils().logger('Edit Screen', value);
            noteGallery![index].note = value;
            Utils().logger('Saved Value',
                'The list has  ${noteGallery![index].note.toString()}');
          },
        ),
      );
    }
  }
}

/// Opens a dialog for inserting images
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
