import 'dart:core';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odessa/constant.dart';
import 'package:odessa/data/datahelper.dart';
import 'package:odessa/pdf_package/thumbnails.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import '../api/pdf_api.dart';
import 'browser.dart';
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
      await getPath();
      setState(() {});
      const CircularProgressIndicator.adaptive();
    } else
    //  check Android version
    if (version > 30) {
      if (status1 == PermissionStatus.granted) {
        await getPath();
        setState(() {});
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
    isDirectory();
    _initialization();
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
  void reload(){
    setState(() => print('reload'));
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
 
      appBar: AppBar(
     backgroundColor: Colors.transparent,
     
     elevation: 0.0,
        leading: 
       
        IconButton(icon:  const FaIcon(
            FontAwesomeIcons.globe,
            size: 20,
            color: Color(0xffCDDEFF),
        ),
         onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Browser()));
        }),
        
         
      
        actions: [
          IconButton(onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  const FavoritePageRoute()));
          }, 
          icon: FaIcon(
            FontAwesomeIcons.bookOpenReader,
            size: 20,
            color: isFavorite ? Colors.red :   const Color(0xffCDDEFF),
          ),)
          
       
        ],
        centerTitle: true,
        title: const Text('Documents', style: TextStyle(
          letterSpacing: 2,
          color: Colors.white),),
      ),
     
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
                    color: Color(0xffEEF2FF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14))),
        child: FutureBuilder<List<File>>(
            future: getPath(),
            builder: (context, AsyncSnapshot<List<File>> snapshot) {
              var data = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (data == null) {
                return Center(child: widgetRequest());
              } else if (data.isEmpty) {
                return Center(
                  child: SizedBox(
                    height: 200,
                    width: 320,
                    child: Card(
                      elevation: 4,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text('No Files found!😥',
                                style: TextStyle(fontSize: 16)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' The app need  stockage 🗝access to display local PDF files'
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                selectionColor: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Text('deny'.toUpperCase())),
                                ElevatedButton(
                                    onPressed: () => checkStoragePermission(),
                                    child: Text('allow'.toUpperCase())),
                              ],
                            )
                          ]),
                    ),
                  ),
                ); //
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isPortrait ? 2 : 4,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int index) {
                        File fileIndex = snapshot.data![index];
      
                        return GestureDetector(
                            onTap: () {
                              openPDF(context, fileIndex);
                            },
                            child: Thumbnails(file: fileIndex, reload:reload));
                      }),
                );
              }
            }),
      ),
      floatingActionButton: MaterialButton(
        padding: const EdgeInsets.all(10),
        minWidth: 60,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xffCDDEFF),
        child: Icon(Icons.folder, size: 35, color: Colors.orange.shade400),
        onPressed: () async {
          final file = await PDFApi.pickFile();
          if (file == null) return;
          openPDF(context, file);
        },
      ),
      resizeToAvoidBottomInset: false,
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

  Future<void> _initialization() async {
    //   Appodeal.setTesting(kReleaseMode ? false : true); //only not release mode
    Appodeal.setLogLevel(Appodeal.LogLevelVerbose);

    Appodeal.setUseSafeArea(true);

    Appodeal.initialize(
        appKey: '8b21b8606550d515198910842f2e66ca937238a3a16bf001',
        adTypes: [
          AppodealAdType.Banner,
        ],
        onInitializationFinished: (errors) {
          errors?.forEach((error) => print(error.desctiption));
          if (kDebugMode) {
            print("onInitializationFinished: errors - ${errors?.length ?? 0}");
          }
        });
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
