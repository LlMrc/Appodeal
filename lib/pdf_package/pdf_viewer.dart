import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

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

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  final controller = PdfViewerController();

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
                elevation: 1.0,
                backgroundColor: Colors.grey[400],
                actions: [
                  IconButton(
                      onPressed: () {
                        controller.setZoomRatio(zoomRatio: 2.0);
                      },
                      icon:
                          const Icon(Icons.zoom_in, color: Color(0xff676FA3))),
                ],
             
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
                child: PdfViewer.openFile(
              widget.file.path,
              viewerController: controller,
              params: const PdfViewerParams(
                  pageDecoration: BoxDecoration(color: Color(0xffEEF2FF)),
                  padding: 0.0),
            )),
          ],
        ),
      ),
    );
  }
}
