import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wakelock/wakelock.dart';


import '../data/crud_operation.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();

    Wakelock.enable();
    super.initState();
  }

  final GlobalKey<SfPdfViewerState> _pdfViwerStateKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));

            // your method where use the context
            // Example navigate:
            _showDialog(details.selectedText.toString());

            _pdfViewerController.clearSelection();
          },
          child: const Text('Copy', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry!);
  }

  _showDialog(String note) async {
    noteController.text = note;
    await Future.delayed(Duration.zero);
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextField(
                autofocus: true,
                controller: titleController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Title..")),
            content: TextField(
              maxLines: 5,
              controller: noteController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Description"),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  addNoteToBox(titleController.text, noteController.text);
                  if (titleController.text.isEmpty) {
                    return;
                  }
                  titleController.clear();
                  noteController.clear();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    final bool isLandScap =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final name = basenameWithoutExtension(widget.file.path);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Visibility(
              visible: isLandScap ? false : true,
              child: AppBar(
                elevation: 0.0,
                backgroundColor: (Colors.grey[400]),           
                actions: [
                  IconButton(
                      onPressed: () {
                        _pdfViewerController.zoomLevel = 1.25;
                      },
                      icon:  Icon(Icons.zoom_in,
                      color:Colors.amber.shade300)),
                ],
                leading: IconButton(
                    onPressed: () {
                      _pdfViwerStateKey.currentState!.openBookmarkView();
                    },
                    icon:  Icon(Icons.bookmark,
                    color:Colors.amber.shade300)),
                title: Text(
                  name,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(),
                ),
                centerTitle: true,
              ),
            ),
            Flexible(
                child: SfPdfViewer.file(
              widget.file,
              key: _pdfViwerStateKey,
              controller: _pdfViewerController,
              enableTextSelection: true,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null && _overlayEntry != null) {
                  _overlayEntry!.remove();
                  _overlayEntry = null;
                } else if (details.selectedText != null &&
                    _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  final SnackBar _snackBar = const SnackBar(
    backgroundColor: Color(0xff006E7F),
    content: Text('your note has been successfully saved'),
    duration: Duration(seconds: 5),
  );
}
