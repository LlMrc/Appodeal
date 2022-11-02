import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../data/datahelper.dart';

import 'edit_note.dart';

class DisplayNote extends StatefulWidget {
  const DisplayNote({
    Key? key,
    required this.noteId,
  }) : super(key: key);
  final Note noteId;

  @override
  State<DisplayNote> createState() => _DisplayNoteState();
}

class _DisplayNoteState extends State<DisplayNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffEEF2FF),
      appBar: AppBar(

        iconTheme: const IconThemeData(color: Color(0xff676FA3)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              widget.noteId.delete();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_forever, color:  Color(0xff676FA3),)),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditNote(
                              note: widget.noteId,
                              
                            )));
              },
              icon: const Icon(Icons.edit, color:  Color(0xff676FA3),)),
          IconButton(
              onPressed: () async {
                await Share.share(
                    "${widget.noteId.title}  \n ${widget.noteId.description}");
              },
              icon: const Icon(Icons.share, color:  Color(0xff676FA3),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white24),
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.noteId.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                     ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(widget.noteId.description,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                         )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
