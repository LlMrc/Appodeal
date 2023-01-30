import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:path/path.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import '../constant.dart';
import '../data/box.dart';
import '../data/datahelper.dart';

class FavoritePageRoute extends StatefulWidget {
  const FavoritePageRoute({Key? key}) : super(key: key);

  @override
  State<FavoritePageRoute> createState() => _FavoritePageRouteState();
}

class _FavoritePageRouteState extends State<FavoritePageRoute> {
  @override
  void initState() {
    super.initState();
    _creatBannerAd();
  }

  bool isAdloaded = false;
  @override
  void dispose() {
    super.dispose();
    Appodeal.destroy(AppodealAdType.Banner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEEF2FF),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffCDDEFF),
              )),
          title: const Text('Favorites Books'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14, left: 8, right: 8),
          child: ValueListenableBuilder<Box<Favorite>>(
              valueListenable: FavoriteBoxes.getFav().listenable(),
              builder: (context, box, _) {
                final currentFavorite = box.values.toList().cast<Favorite>();
                if (currentFavorite.isEmpty) {
                  return const Center(child: Text('No Files'));
                } else {
                  return ListView.builder(
                      itemCount: currentFavorite.length,
                      itemBuilder: (BuildContext context, int index) {
                        File pdfFile =
                            File(currentFavorite[index].favoriteFile);
                        Favorite i = currentFavorite[index];

                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            didssmisFavorite(i);
                          },
                          key: UniqueKey(),
                          background: backGroundDismissble(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  openPDF(context, pdfFile);
                                },
                                iconColor: Colors.blue,
                                leading: SizedBox(
                                    width: 80,
                                    child: PdfDocumentLoader.openFile(
                                        pdfFile.path,
                                        pageNumber: 1,
                                        pageBuilder: (context, textureBuilder,
                                                pageSize) =>
                                            textureBuilder(
                                                size: pageSize,
                                                backgroundFill: true))),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    basenameWithoutExtension(pdfFile.path),
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
              }),
        ),
        bottomNavigationBar: isAdloaded
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: AppodealBanner(
                    adSize: AppodealBannerSize.BANNER, placement: "default"))
            : const SizedBox());
  }

  void didssmisFavorite(Favorite i) {
    i.delete();
  }

  Widget backGroundDismissble() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever, color: Colors.white));
  }

  void initBanner() async {
    bool isinit = await Appodeal.isInitialized(Appodeal.BANNER);
    if (isinit) {
      setState(() => isAdloaded = true);
    }
  }

  void _creatBannerAd() {
    Appodeal.setBannerCallbacks(
        onBannerLoaded: (isPrecache) {
            setState(() => isAdloaded = true);
        },
        onBannerFailedToLoad: () {
          setState(() => isAdloaded = false);
        },
        onBannerShown: () => print('onBannerShown'),
        onBannerShowFailed: () {
          setState(() => isAdloaded = false);
        },
        onBannerClicked: () => print('onBannerClicked'),
        onBannerExpired: () => print('onBannerExpired'));
    initBanner();
  }
}
