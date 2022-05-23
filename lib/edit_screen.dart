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
  List<NoteMedia>? noteGallery;

  String? title;

  bool showDelete = false;
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
    PicDataBase picDataBase = Provider.of<PicDataBase>(context);
    // ShrinkAll shrinkAll = Provider.of<ShrinkAll>(context);

    ///Returns true if the last note is media
    bool canDisplayAddNote() {
      return noteGallery!.last.isMedia;
    }

    /// Add note to the database
    void addNote(Note newNote) async {
      await picDataBase.insertNote(newNote);
    }

    /// Updates an existing [Note]
    void update(Note newNote) async {
      await picDataBase.editNote(newNote);
    }

    bool isNew = widget.isNew;
    String? _title;
    DateTime? date;
    Note? note;
    String? dateString;
    if (firstBuild) {
      // shrinkAll.shrinkAllToggle();
    }
    if (!isNew) {
      note = widget.note!;
      _title = title ?? note.title;
      Utils().logger(cEditNote, cNotNew);
      date = note.date;
      dateString = Date.toDate(date).dateTime;
    } else if (firstBuild) {
      firstBuild = false;
      noteGallery ??= [];
      noteGallery!.add(NoteMedia(id: id, isMedia: false));
      Utils().logger(cEditNote,
          'The list has  ${noteGallery!.length.toString()} element(s)');
    }

    if (isNew) {
      _title = title ?? '';
    }
    dateString ??= Date.toDate(DateTime.now()).date;
    void addTab(NoteMedia newNoteMedia) async {
      noteGallery!.add(newNoteMedia);
    }

    final titleController = TextEditingController(text: _title);
    void addTextField() async {
      final prefs = await SharedPreferences.getInstance();
      int nMID = noteGallery!.length;
      NoteMedia newNoteMedia =
          NoteMedia(id: nMID, isMedia: false, imageUrl: null, note: '');

      addTab(newNoteMedia);
      Utils().logger(cEditNote, 'Added Text Field $nMID');
      setState(() {
        title = prefs.getString(cTitle) ?? '';
      });
      Utils().logger(cTextField, title.toString());
    }

    bool canSaveNote() {
      bool canSaveNote = true;
      if (titleController.text.isEmpty) {
        canSaveNote = false;
      }
      if (noteGallery == null) {
        canSaveNote = false;
      } else if (noteGallery![0].note == 'null' ||
          noteGallery![0].note == null ||
          noteGallery![0].note == '') {
        canSaveNote = false;
      }
      return canSaveNote;
    }

    save() {
      Utils().logger(cEditNote, cSaveButtonTapped);
      _formKey.currentState!.save();
      if (canSaveNote()) {
        if (isNew) {
          Note newNote = Note(
              id: id,
              title: titleController.text,
              date: DateTime.now(),
              subtitle:
                  noteGallery != null ? NoteMedia.encode(noteGallery!) : null);
          if (noteGallery == null) {
            Utils().logger(cEditNote, cNoteGalleryNull);
            navHome(context);
            return;
          } else {
            Utils().logger(cEditNote, cNoteGalleryNotNull);
            addNote(newNote);
            Utils()
                .logger(cEditNote, 'Create: Save Test - ${newNote.subtitle}');
          }
        } else {
          Utils().logger(cEditNote, 'Updated ${widget.id}');
          Note newNote = Note(
            id: note!.id,
            title: titleController.text,
            date: DateTime.now(),
            subtitle: NoteMedia.encode(noteGallery!),
          );
          update(newNote);
          Utils().logger(cEditNote, 'Update: Save Test - ${newNote.subtitle}');
        }
      }

      navHome(context);
    }

    return WillPopScope(
      //Check when back button is pressed
      onWillPop: () async {
        Utils().logger(cEditNote, cBackButtonTapped);
        if (canSaveNote()) {
          Utils().logger(cEditNote, cCanSave);

          exitPrompt(context, save);
        } else {
          Utils().logger(cEditNote, cCantSave);
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Utils().logger(cEditNote, 'The value of Title is: $_title');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(cTitle, _title ?? '');
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
              setState(() {
                title = prefs.getString(cTitle) ?? '';
              });
              return;
            }
            Utils().logger(
                cEditNote, 'Tapped Add Image ${noteGallery![nMID].imageUrl}');
            addTextField();
          },
          child: const Icon(Icons.camera),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              Utils().logger(cEditNote, cBackButtonTapped);
              if (canSaveNote()) {
                Utils().logger(cEditNote, cCanSave);

                exitPrompt(context, save);
              } else {
                Utils().logger(cEditNote, cCantSave);
                navHome(context);
              }
            },
          ),
          title: Text(
            isNew ? cNewNote : cEditNote,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: IconButton(
                  tooltip: isNew ? cSave : cUpdate,
                  icon: Icon(
                    isNew ? Icons.check : Icons.update,
                    size: 30,
                  ),
                  onPressed: () {
                    save();
                  }),
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
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      hintText: cCTitle,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                    onChanged: (value) {
                      Utils().logger(cEditNote, value);

                      _title = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                    child: Stack(
                  children: [
                    noteWidget(noteGallery!, context),
                    if (canDisplayAddNote())
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                            onTap: () => {addTextField()},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Bubble(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    cAddNote,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                            )),
                      )
                  ],
                )),
              ],
            ),
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
        return GestureDetector(
          onLongPress: (() {
            setState(() {
              showDelete = !showDelete;
            });
          }),
          child: Stack(
            children: [
              Align(
                  child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: tile(noteMedia[index], index),
              )),
              displayTile(index),
            ],
          ),
        );
      },
      itemCount: noteMedia.length,
    );
  }

  /// Returns you to the home screen from any point in the app
  navHome(BuildContext context) {
    return Navigator.pop(context);
  }

  /// Retrieves the ID for the particular note
  void initStore() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt(cCurrentID) ?? 0;
  }

  /// Converts encoded string stored in the datatabase to a list of NoteMedia
  void extractNoteMedia() {
    Note? note = widget.note;
    if (note!.subtitle != null && note.subtitle != 'null') {
      String encodedList = note.subtitle.toString();
      try {
        noteGallery = NoteMedia.decode(encodedList);
      } catch (e) {
        noteGallery = [];
        noteGallery?.add(NoteMedia(id: id, isMedia: false, note: encodedList));
      }
    }
  }

  /// Returns A Notemedia tile. It could be a [TextFormField] or an [Image]
  tile(NoteMedia noteMedia, int index) {
    if (noteMedia.isMedia) {
      return Semantics(
        label: cImagePickerMess,
        child: Image.file(File(noteMedia.imageUrl.toString())),
      );
    } else {
      return Builder(builder: (context) {
        return SizedBox(
          child: TextFormField(
            initialValue: noteMedia.note,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.headline1!.color,
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: 17,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
              hintText: cDummyHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            onChanged: (value) {
              Utils().logger(cEditNote, value);
              noteGallery![index].note = value;
              Utils().logger(cSave,
                  'The list has  ${noteGallery![index].note.toString()}');
            },
          ),
        );
      });
    }
  }

  /// Used to include the logic for displaying the delete button
  displayTile(int index) {
    if (showDelete) {
      return Align(
          alignment: Alignment.topRight,
          child: IconButton(
              tooltip: cDelete,
              padding: const EdgeInsets.only(right: 6),
              onPressed: () {
                setState(() {
                  noteGallery!.removeAt(index);
                });
              },
              icon: const Icon(
                Icons.delete_sharp,
                size: 25,
              )));
    } else {
      return const SizedBox();
    }
  }
}

/// Opens a dialog for inserting images
Future<List<XFile>?>? popDialog(context) async {
  Future<List<XFile>?>? imageFiles;
  await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text(cUploadPhoto)),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            imageFiles = Utils().getImage(ImageSource.camera);
            Navigator.pop(context, cCamera);
          },
          child: const Text(cCamera),
        ),
        TextButton(
          onPressed: () {
            imageFiles = Utils().getImages(ImageSource.gallery);

            Navigator.pop(context, cGallery);
          },
          child: const Text(cGallery),
        ),
      ],
    ),
  );
  return imageFiles;
}
