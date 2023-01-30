import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  bool isVisible = false;

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    controller.dispose();
    super.dispose();
  }

  final controller = PdfViewerController();
  Axis direction = Axis.vertical;
  bool changeAxis = true;
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    bool isLandScap =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final name = basenameWithoutExtension(widget.file.path);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Visibility(
              visible: isLandScap ? false : true,
              child: AppBar(
                elevation: 2.0,
                backgroundColor: Colors.grey,
                leading: IconButton(
                    onPressed: () {
                      controller.setZoomRatio(zoomRatio: 2.0);
                    },
                    icon: const Icon(FontAwesomeIcons.magnifyingGlass,
                        color: Color(0xff676FA3))),
                actions: [
                  IconButton(
                    color: const Color(0xff676FA3),
                    icon: changeAxis
                        ? const Icon(Icons.stay_primary_portrait)
                        : const Icon(Icons.stay_current_landscape),
                    onPressed: () {
                      setState(() => changeAxis = !changeAxis);
                      if (changeAxis == true) {
                        setState(() => direction = Axis.horizontal);
                      } else {
                        setState(() => direction = Axis.vertical);
                      }
                    },
                  ),
                ],
                title: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(),
                ),
                centerTitle: true,
              ),
            ),
            Flexible(
                child: PdfViewer.openFile(
              widget.file.path,
              viewerController: controller,
              params: PdfViewerParams(
              
                  scrollDirection: direction,
                  pageDecoration:  BoxDecoration(            
                    border: Border.all(
                      color: Colors.grey.shade400
                    ),
                   color: const Color(0xffEEF2FF)
                  ),
                  padding: 4.0),
            )),
          ],
        ),
      ),
    );
  }
}
