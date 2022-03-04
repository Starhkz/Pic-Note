import 'imports.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  int id = 0;
  int currentId = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    width *= 0.99;
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
          color: Colors.white,
          size: 30,
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => refreshList(),
              child: const Text(
                'NOTEPAD',
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFF242424)),
              child: const TextField(
                style: TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    hintText: "Search for notes",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    icon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    )),
              ),
            )
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SizedBox(width: width, child: noteList()),
      ),
    );
  }

  void refreshList() {
    setState(() {});
  }

  FutureBuilder<List<Note>> noteList() {
    return FutureBuilder<List<Note>>(
      future: PicDataBase().getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Note> notes = snapshot.data!;
          return noteListBuilder(notes);
        } else {
          return const Text(cDummyHint);
        }
      },
    );
  }

  ListView noteListBuilder(List<Note> notes) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          Note note = notes[index];
          return GestureDetector(
            onTap: () => {
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
            onLongPress: () async {
              await PicDataBase().removeNote(note.id);
              log(
                'Removed ${note.id}',
                name: 'List Tile',
              );
              refreshList();
            },
            child: Column(
              children: [
                NoteTile(
                  note: note,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }
}
