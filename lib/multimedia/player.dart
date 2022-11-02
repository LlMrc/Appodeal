import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../api/buttom_package/button_class.dart';


class Player extends StatefulWidget {
  Player(
      {Key? key,
   
      this.firstColor,
      this.thrdColor,
      this.playcolor})
      : super(key: key);
  
  Color? firstColor;
  Color? thrdColor;
  Color? playcolor;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {

 

  bool isPlayed = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 350,
        padding: const EdgeInsets.only(top: 2.0),
        decoration: const BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            Align(
                   alignment: Alignment.topLeft, 
              child: Container(
                    
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: const CurrentSongTitle(),
              ),
            ),
            Stack(alignment: Alignment.center, children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black, //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(-0, -2)
                          //first parameter of offset is left-right
                          //second parameter is top to down
                          ),
                          BoxShadow(
                          color: Colors.black, //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(0, 2)
                       
                          ),
                    ],
                    gradient: LinearGradient(colors: [
                      widget.firstColor ??
                          const Color.fromARGB(255, 227, 138, 96),
                      widget.thrdColor ??
                          const Color.fromARGB(255, 245, 93, 46),
                    ]),
                    borderRadius: BorderRadius.circular(150)),
                height: 250,
                width: 250,
                child: Stack(children: const [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ShuffleButton(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: NextSongButton(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: PreviousSongButton(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RepeatButton(),
                  ),
                ]),
              ),
              Builder(builder: (context) {
                return Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: widget.playcolor ?? Colors.deepOrange.shade400,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black, //color of shadow
                          spreadRadius: 0, //spread radius
                          blurRadius: 1, // blur radius
                          offset:
                              Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50)),
                  child: const PlayButton(),
                );
              }),
            ]),
            const Padding(
              padding: EdgeInsets.only(top: 14.0, right: 14.0, left: 14.0),
              child: SizedBox(),
            )
          ],
        ));
  }
}
