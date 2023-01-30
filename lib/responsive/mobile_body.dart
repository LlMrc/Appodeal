import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: buildPage(),
      bottomNavigationBar: Visibility(
          visible: isSmallScreen(context) ? true : false,
          child: Container(
           margin: EdgeInsets.all(displayWidth * .05),
           width: displayWidth * .155,
              decoration:  BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10)
                  )
                ],
                  // border: const Border.symmetric(
                  // horizontal: BorderSide(width: 0.8, color: Colors.grey)),
                      borderRadius: BorderRadius.circular(50)),
              child: buildNavigation())),
    );
  }

  Widget buildPage() {
    switch (index) {
      case 1:
        return const NotesPage();
      case 2:
        return const Multimedia();
      case 0:
      default:
        return const DocumentListview();
    }
  }

  Widget buildNavigation() {
    return BottomNavyBar(
      iconSize: 22,
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: const Icon(
              FontAwesomeIcons.house,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 2.0,
                )
              ],
            ),
            title: const Text('Home'),
            textAlign: TextAlign.center,
            activeColor: Colors.black87,
            inactiveColor: Colors.red),
        BottomNavyBarItem(
          icon: const Icon(
            FontAwesomeIcons.clipboard,
          ),
          title: const Text('Notes'),
          textAlign: TextAlign.center,
          activeColor: Colors.black,
          inactiveColor: Colors.red,
        ),
        BottomNavyBarItem(
          icon: const Icon(FontAwesomeIcons.music),
          title: const Text('Audio'),
          textAlign: TextAlign.center,
          activeColor: Colors.black,
          inactiveColor: Colors.red,
        ),
      ],
      backgroundColor: const Color(0xffEEF2FF),
      containerHeight: 60,
    );
  }
}
