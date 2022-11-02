
import 'package:flutter/material.dart';

class AnimatedRailWidget extends StatelessWidget {
  const AnimatedRailWidget({Key? key, required this.child, required this.isExtanded}) : super(key: key);
  final Widget child;
  final VoidCallback isExtanded;



@override
  Widget build(BuildContext context) {
    final animation = NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Container(
        padding: const EdgeInsets.only(top:14),
          height: 56,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: FloatingActionButton.extended(
                backgroundColor: Colors.red,
                isExtended: animation.status != AnimationStatus.dismissed,
                onPressed: ()  => isExtanded(),
                label: child!),
          )),
      child: child,
    );
  }
}
