import 'package:flutter/material.dart';



import '../multimedia/multimedia.dart';

import '../note_package/notes_page.dart';
import 'animated_rail_widget.dart';
import 'mobile_body.dart';

class TableteBody extends StatefulWidget {
  const TableteBody({Key? key}) : super(key: key);

  @override
  State<TableteBody> createState() => _TableteBodyState();
}

class _TableteBodyState extends State<TableteBody> {
   bool isExpanded = false;
  void extendedCallBack() {
    setState(() => isExpanded = !isExpanded);
  }

  int index = 0;
 
  final selectedColor = Colors.white;
  final unselectedColor = Colors.white38;
  final labelStyle = const TextStyle(fontWeight: FontWeight.w900, fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Row(
        children: [
          NavigationRail(
              leading: Material(
                  clipBehavior: Clip.hardEdge,
                  shape: const CircleBorder(),
                  child: InkWell(
                      onTap: () => setState(() => isExpanded = !isExpanded),
                      child: Ink.image(
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          image: const AssetImage('assets/logo.png')))),
              selectedLabelTextStyle: labelStyle.copyWith(color: selectedColor),
              groupAlignment: 0,
              unselectedLabelTextStyle:
                  labelStyle.copyWith(color: unselectedColor),
              selectedIconTheme:
                  const IconThemeData(color: Colors.white, size: 30),
              extended: isExpanded,
              unselectedIconTheme: const IconThemeData(color: Colors.white38),
              backgroundColor: const Color(0xff0F52BA),
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationRailDestination(
                    selectedIcon: Icon(Icons.apps),
                    icon: Icon(Icons.home),
                    label: Text('Home')),
                NavigationRailDestination(
                    selectedIcon: Icon(Icons.sticky_note_2),
                    icon: Icon(Icons.sticky_note_2_outlined),
                    label: Text('Note')),
                NavigationRailDestination(
                    selectedIcon: Icon(Icons.music_note),
                    icon: Icon(Icons.music_note),
                    label: Text('Audio')),
              ],
              trailing: AnimatedRailWidget(
                isExtanded:extendedCallBack,
                child: isExpanded
                    ? Row(
                        children: const [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 28,
                          ),

                          SizedBox(width: 10,),
                          Text('Logout')
                        ],
                      )
                    : const Icon(Icons.logout),
              )),
          Expanded(child: buildPage())
        ],
      )),
    );
  }

  Widget buildPage() {
    switch (index) {
      case 0:
        return const MobileBody();
      case 1:
        return const NotesPage();
      case 2:
        return const Multimedia();
    }
    return const MobileBody();
  }
}
