import 'package:pic_note/big_screens/edit_screen_tab.dart';
import 'package:pic_note/imports.dart';
import 'package:flutter/material.dart';
import 'package:pic_note/models/screen_data.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    lowerBound: 0,
    duration: const Duration(milliseconds: 200),
    reverseDuration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

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
    double height = MediaQuery.of(context).size.height;
    // width *= 0.99;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          ScreenDataNotifier().screenData = const ScreenData(
            isNewNote: true,
          ),
          _controller.forward(),
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          onTap: () {
            // refreshList();
            _controller.stop();
          },
          onDoubleTap: () {
            _controller.forward();
          },
          onLongPress: () {
            _controller.reverse();
          },
          child: Text(
            'Note Pad For Tab Width $width',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          double reverse = (animation.value - 1).abs();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0.2 * width, 0),
                child: Transform.translate(
                  offset: Offset(width * -0.2 * animation.value, 0),
                  child: Center(
                    child: SizedBox(
                      width: width * .65,
                      child: RefreshIndicator(
                          onRefresh: () {
                            setState(() {});
                            return picDataBase.getNotes();
                          },
                          child: Center(
                            child: SizedBox(
                                width: width * 0.6,
                                child: Consumer<PicDataBase>(
                                    builder: (_, value, __) {
                                  return noteList(value);
                                })),
                          )),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: animation.value,
                child: Transform.translate(
                  offset: Offset(0, height * reverse),
                  child: SizedBox(
                      width: 0.35 * width,
                      child:
                          Consumer<ScreenDataNotifier>(builder: (_, value, __) {
                        Note? note = ScreenDataNotifier().screenData?.note;
                        bool isNew =
                            ScreenDataNotifier().screenData?.isNewNote ?? true;
                        return EditScreenTab(
                          id: note?.id ?? id,
                          isNew: isNew,
                          controller: _controller,
                          note: note,
                        );
                      })),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void refreshList() {
    setState(() {});
  }

  FutureBuilder<List<Note>> noteList(PicDataBase value) {
    return FutureBuilder<List<Note>>(
      future: value.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                    onTap: () {
                      {
                        setState(() {});
                        log(
                          'Tapped ${note.id}',
                          name: 'List Tile',
                        );
                        ScreenDataNotifier().screenData = ScreenData(
                          note: note,
                          isNewNote: false,
                        );
                        _controller.forward();
                      }
                    },
                    child: NoteTile(
                      note: note,
                      canExpand: true,
                    )),
              ),
            ),
          );
        });
  }
}
