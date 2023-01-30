import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/crud_operation.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> {
  var titleController = TextEditingController();
  var descController = TextEditingController();

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF2FF),
        body: Column(
          children: [
            Visibility(
              visible: _isLandScape ? false : true,
              child: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                titleTextStyle: const TextStyle(color: Colors.black),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('📝Add Note'.toUpperCase()),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffCDDEFF),
                            elevation: 4,
                            fixedSize: const Size(70, 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (titleController.text.isEmpty) {
                            titleController.text = "No Title";
                          } else if (descController.text.isEmpty) {
                            descController.text = 'No Notes Found!';
                          }
                          await addNoteToBox(
                              titleController.text, descController.text);
                          titleController.clear();
                          descController.clear();

                          if (!mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Save".toUpperCase(),
                          style: const TextStyle(color: Color(0xff676FA3)),
                        )),
                  )
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                    reverse: true,
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Card(
                          shadowColor: Colors.grey,
                          elevation: 4,
                          child: TextFormField(
                              textInputAction: TextInputAction.go,
                              controller: titleController,
                              decoration: InputDecoration(
                                isDense: true,
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    Icon(Icons.edit, color: Colors.grey[400]),
                                hintText: 'Title...',
                              )),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Card(
                        shadowColor: Colors.grey,
                        borderOnForeground: false,
                        elevation: 4,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: descController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Description'),
                              hoverColor: Colors.indigo),
                          maxLines: 6,
                        ),
                      )
                    ].reversed.toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
