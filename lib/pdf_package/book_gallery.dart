import 'dart:core';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:odessa/constant.dart';
import 'package:odessa/pdf_package/thumbnails.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/pdf_api.dart';
import '../multimedia/page_manager.dart';
import '../service/service.dart';
import 'favorite_pdf.dart';

class DocumentListview extends StatefulWidget {
  const DocumentListview({Key? key}) : super(key: key);

  @override
  _DocumentListviewState createState() => _DocumentListviewState();
}

late PermissionStatus status;

class _DocumentListviewState extends State<DocumentListview> {
  ///////////////////////// REQUEST PERMISSION////////////////////////////

  Future<void> checkStoragePermission() async {
    status = await Permission.storage.request();
    var status1 = (await Permission.manageExternalStorage.request());

    String getVersion = await getPhoneVersion();
    int version = int.parse(getVersion);
    // get  storage  permission
    if (status == PermissionStatus.granted) {
      const CircularProgressIndicator.adaptive();
      setState(() {});
      getIt<PageManager>().init();
      await getPath();
    } else
    //  check Android version
    if (version > 30) {
      if (status1 == PermissionStatus.granted) {
        setState(() {});
        getIt<PageManager>().init();
        await getPath();
      } else if (status1 == PermissionStatus.denied) {
        setState(() => alertDialog(status1));
      }
    } else {
      setState(() => alertDialog(status));
    }
  }

  ///           ***get directory by VERSION***
  bool isDir = true;

  void isDirectory() async {
    String getVersion = await getPhoneVersion();
    int version = int.parse(getVersion);
    if (version >= 30) {
      setState(() => isDir = true);
    } else {
      setState(() => isDir = false);
    }
  }

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    isDirectory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<File>> getPath() async {
    final List<File> exfilePath = [];
    Directory dir = isDir
        ? Directory('/storage/emulated/0/Download')
        : Directory('/storage/emulated/0/');

    List<FileSystemEntity> files = dir.listSync(recursive: true);
    for (FileSystemEntity file in files) {
      FileStat f = file.statSync();
      if (f.type == FileSystemEntityType.file && file.path.contains('.pdf')) {
        File g = File(file.path);
        setState(() {
          exfilePath.add(g);
        });
      }
    }
    return exfilePath;
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  void reload() {
    setState(() => print('reload'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xffFF5959)));
    Size size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Color(0xffEEF2FF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          child: FutureBuilder<List<File>>(
              future: getPath(),
              builder: (context, AsyncSnapshot<List<File>> snapshot) {
                var data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data == null) {
                  return Center(child: widgetRequest());
                } else if (data.isEmpty) {
                  return Center(child: widgetRequest());
                  // return Center(
                  //   child: Card(
                  //     elevation: 4,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(10.0),
                  //       child: AnimatedTextKit(
                  //           repeatForever: true,
                  //           animatedTexts: [
                  //             FadeAnimatedText('No Files found!😥',
                  //                 textStyle: const TextStyle(fontSize: 24))
                  //           ]),
                  //     ),
                  //   ),
                  // ); //
                } else {
                  return Container(
                    height: size.height,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const TitleBar(),
                        Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      childAspectRatio: 3 / 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, int index) {
                                File fileIndex = snapshot.data![index];

                                return GestureDetector(
                                    onTap: () {
                                      openPDF(context, fileIndex);
                                    },
                                    child: Thumbnails(
                                        file: fileIndex, reload: reload));
                              }),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
        floatingActionButton: Visibility(
          visible: isPortrait ? true : false,
          child: MaterialButton(
            padding: const EdgeInsets.all(10),
            minWidth: 60,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: const Color(0xffCDDEFF),
            child: Icon(Icons.folder, size: 35, color: Colors.orange.shade400),
            onPressed: () async {
              final file = await PDFApi.pickFile();
              if (file == null) return;
              if (mounted) return;
              openPDF(context, file);
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        extendBody: true,
      ),
    );
  }

  ClipRRect widgetRequest() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.grey.shade300,
        height: 150,
        width: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
                'The app need your 🗝permission to display local PDF files'
                    .toUpperCase(),
                style: const TextStyle(fontSize: 16)),
            ElevatedButton(
                onPressed: () async {
                  await checkStoragePermission();
                  setState(() {});
                },
                child: const Text(
                  '📂 OPEN',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }

  Future<String> getPhoneVersion() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid) {
      return androidInfo.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion.toString();
    } else {
      throw UnimplementedError();
    }
  }

  void alertDialog(PermissionStatus status) {
    if (status.isDenied) {
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: const Text(
                      "Odessa need to access your storage to display pdf files"),
                  title: const Text("Alert!"),
                  actions: [
                    ElevatedButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                        child: const Text("OK"),
                        onPressed: () {
                          checkStoragePermission();
                        }),
                  ],
                ));
      });
    }
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        height: 40,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('PDF Books and Magazines',
              style: TextStyle(
                  fontFamily: 'explora',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2)),
          FloatingActionButton.small(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritePageRoute()));
            },
            child: FaIcon(FontAwesomeIcons.bookBookmark,
                size: 20, color: Colors.grey.shade700),
          ),
        ]));
  }
}
