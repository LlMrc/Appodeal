
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: buildPage(),
      bottomNavigationBar: Visibility(
        visible: isSmallScreen(context)? true: false,
        child: Container(
          decoration: const BoxDecoration(border:Border.symmetric(horizontal: BorderSide(width: 0.8, color: Colors.grey)) ),
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
            icon:  const Icon(Icons.apps, shadows: [
              Shadow(color: Colors.black54,
              blurRadius: 2.0,
             )
            ],),
            title: const Text('Home'),
            textAlign: TextAlign.center,
            activeColor:   Colors.black87,
            inactiveColor: Colors.red),
        BottomNavyBarItem(
          icon: const Icon(
            Icons.sticky_note_2,
          ),
          title: const Text('Note'),
          textAlign: TextAlign.center,
          activeColor:  Colors.black,
          inactiveColor: Colors.red,
        ),
        BottomNavyBarItem(
          icon:  const Icon(
          Icons.music_note_outlined,
          ),
          title: const Text('Audio'),
          textAlign: TextAlign.center,
          activeColor:  Colors.black,
          inactiveColor: Colors.red,
        ),
      ],
      backgroundColor:  const Color(0xffEEF2FF),
     
      containerHeight: 60,
    );
  }
}



