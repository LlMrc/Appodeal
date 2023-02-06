import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:odessa/browser_page/wiki_page.dart';
import '../constant.dart';
import '../multimedia/multimedia.dart';
import '../note_package/notes_page.dart';
import '../pdf_package/book_gallery.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPage(),
      bottomNavigationBar: Visibility(
          visible: isSmallScreen(context) ? true : false,
          child: buildNavigation()),
    );
  }

  Widget buildPage() {
    switch (index) {
      case 1:
        return const DocumentListview();
      case 2:
        return const NotesPage();
      case 3:
        return const Multimedia();
      case 0:
      default:
        return const MyWikiPage();
    }
  }

  Widget buildNavigation() {
    return CurvedNavigationBar(
      height: 54,
      animationDuration: const Duration(milliseconds: 300),
      color: const Color(0xffFF5959),
      index: index,
      onTap: (index) =>
        setState(() {
           this.index = index;
if (index != 0) {
         isInitiated = false;
          }}),
        
      items: const [
        Icon(
          FontAwesomeIcons.wikipediaW,
          color: Color(0xffEEF2FF),
          size: 20,
        ),
        Icon(
          Icons.apps,
          color: Color(0xffEEF2FF),
        ),
        Icon(FontAwesomeIcons.clipboard, color: Color(0xffEEF2FF), size: 20),
        Icon(Icons.music_note, color: Color(0xffEEF2FF)),
      ],
      backgroundColor: const Color(0xffEEF2FF),
    );
  }
}
