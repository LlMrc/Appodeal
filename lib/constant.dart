import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:odessa/pdf_package/pdf_viewer.dart';

double smallScreen = 480;

bool isSmallScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < smallScreen;
}

void openPDF(BuildContext context, File file) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
    );
bool isInitiated = true;
