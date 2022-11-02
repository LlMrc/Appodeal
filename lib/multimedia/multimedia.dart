import 'package:audio_service/audio_service.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:odessa/multimedia/page_manager.dart';
import 'package:odessa/multimedia/player.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import '../api/buttom_package/button_class.dart';
import '../service/service.dart';

class Multimedia extends StatefulWidget {
  const Multimedia({
    Key? key,
  }) : super(key: key);
  @override
  State<Multimedia> createState() => _MultimrdiaState();
}

class _MultimrdiaState extends State<Multimedia> {
  bool isAldloaded = false;

  Future isInit() async {
    bool isInitialize = await Appodeal.isInitialized(AppodealAdType.Banner);
    if (isInitialize == true) {
      setState(() => isAldloaded = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _creatBannerAd();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    super.dispose();
    Appodeal.destroy(AppodealAdType.Banner);
  }

  final pageManager = getIt<PageManager>();
  final _audioHandler = getIt<AudioHandler>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.grey));
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
          body: Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14)),
                image: DecorationImage(
                  image: AssetImage("assets/musicads.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Visibility(
                      visible: isPortrait ? true : false,
                      child: isAldloaded
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: AppodealBanner(
                                  adSize: AppodealBannerSize.BANNER,
                                  placement: "default"))
                              
                          : Container(
                              alignment: Alignment.center,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 6),
                              color: Colors.white12,
                              child: const Text('A U D I O  P L A Y E R',
                                  style: TextStyle(
                                      shadows: [
                                        Shadow(
                                            color: Colors.grey,
                                            offset: Offset(1, -1))
                                      ],
                                      color: Colors.white,
                                      letterSpacing: 2.0))),
                                      ),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: pageManager.playlistNotifier,
                    builder: (context, playlistTitles, _) {
                      return Flexible(
                        child: ListView.builder(
                          itemCount: playlistTitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Column(
                                children: [
                                  Card(
                                      color: Colors.white30,
                                      child: ListTile(
                                          leading: const CircleAvatar(
                                              child: Icon(
                                            Icons.headphones,
                                            color: Colors.white,
                                          )),
                                          title: Text(playlistTitles[index],
                                              maxLines: 2,
                                              overflow: TextOverflow.fade),
                                          onTap: () async {
                                            await _audioHandler
                                                .skipToQueueItem(index);
                                            _audioHandler.play();
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) =>
                                                    buildSheet());
                                          })),
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
            visible: isPortrait? true: false,
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
          )),
    );
  }

  void _creatBannerAd() {
    Appodeal.setBannerCallbacks(
        onBannerLoaded: (isPrecache) => print('is : $isPrecache'),
        onBannerFailedToLoad: () {
          setState(() => isAldloaded = false);
        },
        onBannerShown: () => print('onBannerShown'),
        onBannerShowFailed: () => print('onBannerShowFailed'),
        onBannerClicked: () => print('onBannerClicked'),
        onBannerExpired: () => print('onBannerExpired'));
    isInit();
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
}
