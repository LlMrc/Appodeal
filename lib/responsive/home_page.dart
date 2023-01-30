import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odessa/responsive/tablet_body.dart';
import 'package:odessa/service/service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant.dart';
import '../multimedia/page_manager.dart';
import 'mobile_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
   getIt<PageManager>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      if (width > smallScreen) {
        return const TableteBody(
      
        );
      }
      return const MobileBody();
    });
  }

}
