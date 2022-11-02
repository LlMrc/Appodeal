import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../data/crud_operation.dart';
import '../data/datahelper.dart';

bool isFavorite = false;

class Thumbnails extends StatefulWidget {
  Thumbnails({Key? key, required this.file, required this.reload})
      : super(key: key);
  final File file;
  VoidCallback reload;

  @override
  State<Thumbnails> createState() => _ThumbnailsState();
}

class _ThumbnailsState extends State<Thumbnails> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
        header: Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              offset: const Offset(5.0, 4.0),
              elevation: 4,
              color: Colors.blue[50],
              itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: () async {
                          final Favorite favkey =
                              await addFavorite(widget.file.path);
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          if (isFavorite == false) {
                            favkey.delete();
                          } else {
                            favkey.delete();
                          }
                        },
                        child: menuItem(
                            Icon(
                              Icons.favorite,
                              color: isFavorite
                                  ? Colors.red[700]
                                  : Colors.deepPurple[300],
                            ),
                            'Favorite')),
                    PopupMenuItem(
                      onTap: () async {
                        await Share.shareFiles([widget.file.path],
                            text:
                                'https://play.google.com/store/apps/details?id=com.dev.odeappo');
                      },
                      value: 2,
                      child: menuItem(
                          Icon(
                            Icons.share,
                            color: Colors.deepPurple[300],
                          ),
                          'Share'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        deleteFile(widget.file);
                        widget.reload();
                      },
                      value: 2,
                      child: menuItem(
                          Icon(Icons.delete, color: Colors.deepPurple[300]),
                          "Delete"),
                    ),
                  ]),
        ),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3.0,
                      color: Colors.black54,
                      offset: Offset(-2.0, 2.3))
                ],
                color: Color(0xFFF6F4ED)),
            child: PdfDocumentLoader.openFile(widget.file.path,
                pageNumber: 1,
                pageBuilder: (context, textureBuilder, pageSize) =>
                    textureBuilder(size: pageSize, backgroundFill: true))));
  }

  Widget menuItem(Icon icon, String label) {
    return Row(children: [
      icon,
      const SizedBox(
        width: 12,
      ),
      Text(label)
    ]);
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
}
