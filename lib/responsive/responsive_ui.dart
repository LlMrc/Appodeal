import 'package:flutter/cupertino.dart';
import 'package:odessa/responsive/tablet_body.dart';

import '../constant.dart';
import 'mobile_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      if (width > smallScreen) {
        return const TableteBody();
      }
      return const MobileBody();
    });
  }
}
