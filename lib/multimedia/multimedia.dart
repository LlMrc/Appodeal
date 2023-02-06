import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:odessa/constant.dart';
import 'package:odessa/multimedia/page_manager.dart';
import 'package:odessa/multimedia/player.dart';

import '../service/service.dart';

class Multimedia extends StatefulWidget {
  const Multimedia({
    Key? key,
  }) : super(key: key);

  @override
  State<Multimedia> createState() => _MultimrdiaState();
}

class _MultimrdiaState extends State<Multimedia> {
  @override
  void initState() {
    super.initState();
    _creatBannerAd();
  }

  bool isAldloaded = false;
  BannerAd? _bannerAds;
  final pageManager = getIt<PageManager>();
  final _audioHandler = getIt<AudioHandler>();

  @override
  void dispose() {
    _bannerAds!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xffFF5959)));

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              image: DecorationImage(
                image: AssetImage("assets/musicads.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Visibility(
                    visible: isPortrait ? true : false, child: buildContent()),
                ValueListenableBuilder<List<String>>(
                  valueListenable: pageManager.playlistNotifier,
                  builder: (context, playlistTitles, _) {
                    return Flexible(
                      child: ListView.builder(
                        itemCount: playlistTitles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white10,
                                      border: Border.all(color: Colors.grey)),
                                  child: ListTile(
                                      leading: const CircleAvatar(
                                          child: Icon(
                                        Icons.headphones,
                                        color: Colors.black,
                                      )),
                                      title: Text(playlistTitles[index],
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    // blurRadius: 1,

                                                    offset: Offset(1, -1))
                                              ]),
                                          overflow: TextOverflow.fade),
                                      onTap: () async {
                                        await _audioHandler
                                            .skipToQueueItem(index);

                                        _audioHandler.play();
                                        if (!mounted) return;
                                        isSmallScreen(context)
                                            ? showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) =>
                                                    buildSheet())
                                            : null;
                                      }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: isPortrait ? true : false,
          child: FloatingActionButton.small(
            backgroundColor: const Color(0xffCDDEFF),
            onPressed: () {
              isPortrait
                  ? showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => buildSheet())
                  : null;
            },
            child: const Icon(
              Icons.music_note_outlined,
              color: Colors.black,
            ),
          ),
        ),
        extendBody: true,
      ),
    );
  }

  void _creatBannerAd() {
    _bannerAds = BannerAd(
        size: AdSize.banner,
        adUnitId: randomId(),
        listener: BannerAdListener(
          onAdLoaded: (ad) => setState(() => isAldloaded = true),
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
      idList[Random().nextInt(idList.length)];
    print(randomIndex);
    return randomIndex;
  }

  Widget buildSheet() => makeDissmisble(
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.5,
          builder: (_, controller) => Center(child: Player()),
        ),
      );

  Widget makeDissmisble({required DraggableScrollableSheet child}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildContent() => isAldloaded
      ? Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          height: 58,
          child: AdWidget(ad: _bannerAds!),
        )
      : Container(
          alignment: Alignment.center,
          height: _bannerAds!.size.height.toDouble(),
          width: _bannerAds!.size.width.toDouble(),
          margin: const EdgeInsets.only(bottom: 6),
          color: Colors.white12,
          child: const Text('A U D I O  P L A Y E R',
              style: TextStyle(
                  shadows: [Shadow(color: Colors.grey, offset: Offset(1, -1))],
                  color: Colors.white,
                  letterSpacing: 2.0)));
}
