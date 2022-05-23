import 'imports.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool shrinkAll = false;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  int id = 0;
  int currentId = 0;
  @override
  Widget build(BuildContext context) {
    PicDataBase picDataBase = Provider.of<PicDataBase>(context);
    double width = MediaQuery.of(context).size.width;
    // width *= 0.99;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EditScreen(
                        id: currentId,
                        isNew: true,
                      )))
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            onPressed: () async {
              List<Note> notes = await picDataBase.getNotes();
              showSearch(context: context, delegate: SearchBar(notes: notes));
            },
          ),
        ],
        elevation: 0,
        title: GestureDetector(
          onTap: () => refreshList(),
          child: const Text(
            cNotePad,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return picDataBase.getNotes();
          },
          child: Center(
            child: SizedBox(
                width: width,
                child: Consumer<PicDataBase>(builder: (_, value, __) {
                  return noteList(value);
                })),
          )),
    );
  }

  void refreshList() {
    setState(() {});
  }

  FutureBuilder<List<Note>> noteList(PicDataBase value) {
    return FutureBuilder<List<Note>>(
      future: value.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Note> notes = snapshot.data!;
          return noteListBuilder(notes);
        } else {
          Utils().logger(cHome, 'No Notes');
          return const Center(
            child: Text(
              cDummyHint,
              style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            ),
          );
        }
      },
    );
  }

  ListView noteListBuilder(List<Note> notes) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          PicDataBase picDataBase = Provider.of<PicDataBase>(context);
          Note note = notes[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                shrinkAll = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Slidable(
                // Specify a key if the Slidable is dismissible.
                key: UniqueKey(),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(onDismissed: () {
                    picDataBase.removeNote(note.id);
                    refreshList();
                  }),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: ((context) {
                        picDataBase.removeNote(note.id);
                      }),
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: ((context) {
                        labelDialog(context, note, index);
                      }),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.label,
                      label: 'Label',
                    ),
                  ],
                  dismissible: DismissiblePane(onDismissed: () {
                    refreshList();
                  }),
                ),
                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: GestureDetector(
                    onTap: () => {
                          setState(() {}),
                          log(
                            'Tapped ${note.id}',
                            name: 'List Tile',
                          ),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditScreen(
                                        note: note,
                                        id: note.id,
                                        isNew: false,
                                      )))
                        },
                    child: NoteTile(note: note, canExpand: true)),
              ),
            ),
          );
        });
  }
}
