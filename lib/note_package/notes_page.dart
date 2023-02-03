import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:odessa/note_package/sticky_note.dart';

import '../data/box.dart';
import '../data/datahelper.dart';
import 'add_note.dart';
import 'display_note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xffFF5959)));
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
                height: 40,
                child: Center(
                    child: Text('S T I C K Y  N O T E S',
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 16,
                            color: Colors.white)))),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Color(0xffEEF2FF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14))),
                child: ValueListenableBuilder<Box<Note>>(
                    valueListenable: NoteBoxes.getNotes().listenable(),
                    builder: (context, box, _) {
                      final currentNote = box.values.toList().cast<Note>();
                      if (currentNote.isEmpty) {
                        return  Center(
                          child: AnimatedTextKit(
                            isRepeatingAnimation: true,
                           
                            animatedTexts: [
                                FadeAnimatedText('No notes added yet',   textStyle: const TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 2,
                                      
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue)),
                                TyperAnimatedText('Add Notes!',   textStyle: const TextStyle(
                                          fontSize: 30,
                                          letterSpacing: 2,
                                       
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue)),
                                
                               ],
                              ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildContent(currentNote),
                      );
                    }),
              ),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: isPortrait ? true : false,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xffCDDEFF),
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AddNote()));
            },
            label: const Text(
              'Add',
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(Icons.add, color: Colors.black),
          ),
        ),
        extendBody: true,
      ),
    );
  }

  Widget buildContent(List<Note> transact) {
    return GridView.builder(
        itemCount: transact.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          final currentNote = transact[index];
          return Stack(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DisplayNote(
                                  noteId: currentNote,
                                )));
                  },
                  child: StickyNoteContainer(
                    color: color[index % color.length],
                    createdDate: currentNote.createdDate,
                    name: currentNote.description,
                    title: currentNote.title,
                  )),
              Positioned(
                  right: -10,
                  top: -10,
                  child: IconButton(
                      onPressed: () => currentNote.delete(),
                      icon: Icon(
                        FontAwesomeIcons.thumbtack,
                        size: 14,
                        color: Colors.blue[800],
                        shadows: const [
                          Shadow(offset: Offset(-1, 0), color: Colors.white)
                        ],
                      )))
            ],
          );
        });
  }

  List<Color> color = const [
    Color.fromARGB(255, 219, 221, 97),
    Color.fromARGB(255, 103, 135, 190),
     Color.fromARGB(255, 54, 165, 133),
    Color.fromARGB(255, 177, 89, 189),
    Color.fromARGB(255, 128, 43, 43),  
    Color.fromARGB(255, 44, 143, 189),
    Color.fromARGB(255, 180, 196, 90),
    Color.fromARGB(255, 185, 102, 19),
    Color.fromARGB(255, 201, 95, 123),
  ];
}
