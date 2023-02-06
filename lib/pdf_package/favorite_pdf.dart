import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

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
  BannerAd? _bannerAd;

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEEF2FF),
        body: Column(
          children: [
            const TitleBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Color(0xffEEF2FF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14))),
                child: ValueListenableBuilder<Box<Favorite>>(
                    valueListenable: FavoriteBoxes.getFav().listenable(),
                    builder: (context, box, _) {
                      final currentFavorite =
                          box.values.toList().cast<Favorite>();
                      if (currentFavorite.isEmpty) {
                        return Center(
                            child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('No Files Found',
                                textStyle: TextStyle(
                                    color: Colors.purple.shade200,
                                    fontFamily: 'aboreto',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700))
                          ],
                        ));
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
                                    color: Colors.blue[50],
                                    shadowColor: Colors.deepPurple,
                                    elevation: 4,
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
                                              pageBuilder: (context,
                                                      textureBuilder,
                                                      pageSize) =>
                                                  textureBuilder(
                                                      size: pageSize,
                                                      backgroundFill: true))),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          basenameWithoutExtension(
                                              pdfFile.path),
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
            ),
          ],
        ),
        bottomNavigationBar: isAdloaded
            ? Container(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                margin: const EdgeInsets.all(8.0),
                child: AdWidget(ad: _bannerAd!),
              )
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

  void _creatBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: randomId(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() => isAdloaded = true),
          onAdFailedToLoad: (ad, error) => print('$ad $error'),
        ),
        request: const AdRequest())
      ..load();
  }

  String randomId() {
    List<String> idList = [
      "ca-app-pub-3900780607450933/3192254480",
      "/120940746/pub-72844-android-4898"
    ];
    String randomIndex =
        (idList..shuffle()).first; //idList[Random().nextInt(idList.length)];
    print(randomIndex);
    return randomIndex;
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
          )),
      title: const Text('Favorites Books',
          style: TextStyle(
            fontFamily: 'aboreto',
          )),
    );
  }
}
