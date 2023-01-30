import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/crud_operation.dart';
import '../data/datahelper.dart';

class EditNote extends StatefulWidget {
  const EditNote({Key? key, required this.note}) : super(key: key);
  final Note note;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    descController.text = widget.note.description;
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: const Color(0xff2C394B),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(children: [
            Visibility(
              visible: _isLandScape ? false : true,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: const Text(
                  'Edit..',
                  style: TextStyle(color: Colors.blue),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        editNote(widget.note, titleController.text,
                            descController.text);
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        "Save".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.amber.shade200),
                      ))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              height: 700,
              child: Column(children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  color: Colors.white10,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white60, fontSize: 18),
                    controller: titleController,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 400,
                  child: TextField(
                    maxLines: 16,
                    cursorColor: Colors.amber[200],
                    style: const TextStyle(color: Colors.white60, fontSize: 16),
                    controller: descController,
                  ),
                ),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
