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
  @override
  void initState() {
    super.initState();
    initStore();
  }

  void initStore() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt(cCurrentID)!;
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
    return Scaffold(
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
                log(
                  'Tapped ${widget.id}',
                  name: 'Edit Screen',
                );
                _formKey.currentState!.save();
                if (isNew) {
                  Note newNote = Note(
                      id: id,
                      title: _title.toString(),
                      date: DateTime.now().day.toString(),
                      subtitle: _note.toString());
                  addNote(newNote);
                } else {
                  log(
                    'Updated ${widget.id}',
                    name: 'List Tile',
                  );
                  Note newNote = Note(
                      id: note!.id,
                      title: _title.toString(),
                      date: DateTime.now().day.toString(),
                      subtitle: _note.toString());
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
      body: Form(
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
              SizedBox(
                child: TextFormField(
                  initialValue: _note,
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
                    _note = value;
                  },
                ),
              )
            ],
          ),
        ),
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
}

void update(Note newNote) async {
  await PicDataBase().editNote(newNote);
}
