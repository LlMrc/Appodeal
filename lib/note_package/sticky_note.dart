import 'package:flutter/material.dart';
import 'dart:math';
import 'sticky_painter.dart';

class StickyNoteContainer extends StatelessWidget {
  const StickyNoteContainer(
      {Key? key,
      required this.createdDate,
      required this.name,
      required this.title,
      required this.color})
      : super(key: key);
  final Color color;
  final String name;
  final String title;
  final DateTime createdDate;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 300,
            height: 300,
            child: StickyNote(
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,                   
                  maxLines: 5,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            )));
  }
}

class StickyNote extends StatelessWidget {
  const StickyNote({Key? key, required this.child, required this.color}) :super(key: key);

  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.01 * pi,
      child: CustomPaint(
          painter: StickyNotePainter(color: color),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          )),
    );
  }
}
