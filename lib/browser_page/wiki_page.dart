import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:odessa/browser_page/browser.dart';
import 'package:wikidart/wikidart.dart';

import '../api/admob_service.dart';
import '../constant.dart';

class MyWikiPage extends StatefulWidget {
  const MyWikiPage({super.key});

  @override
  State<MyWikiPage> createState() => _MyWikiPageState();
}

class _MyWikiPageState extends State<MyWikiPage> {
  TextEditingController searchController = TextEditingController();
  InterstitialAd? interstitialAd;
  void initialInterstia() {
    setState(() => isInitiated = true);
  }


  @override
  void initState() {
    super.initState();

    _createInterstitialAd();
    _showInterstitialAds();
  }

  
  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffFF5959),
          body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Color(0xffEEF2FF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14))),
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: 50,
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: SizedBox(
                          child: TextField(
                            onSubmitted: (value) {
                              setState(() => value = searchController.text);
                            },
                            controller: searchController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              fillColor: Colors.red.shade100,
                              labelText: 'Search',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const Browser()));
                            },
                            icon: Icon(
                              FontAwesomeIcons.globe,
                              color: Colors.purple.shade200,
                            )),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<WikiResponse?>(
                    future: wikiResult(),
                    builder: (context, snapshot) {
                      var google = snapshot.data;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
                        return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 200),
                              child: AnimatedTextKit(
                                                      animatedTexts: [
                              WavyAnimatedText('No Internet connection ⏳',
                                  textStyle: const TextStyle(
                                      color: Colors.purple, fontSize: 24))
                                                      ],
                                                    ),
                            ));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText('No Internet connection ⏳',
                                textStyle: const TextStyle(
                                    color: Colors.purple, fontSize: 24))
                          ],
                        ));
                      }

                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: ListView(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      google!.title ?? 'No title',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'aboreto',
                                        letterSpacing: 4,
                                      ),
                                    ),
                                    AnimatedTextKit(
                                      isRepeatingAnimation: false,
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                            google.description ??
                                                'No Description',
                                            textStyle: const TextStyle(
                                                fontSize: 25,
                                                letterSpacing: 2,
                                                fontFamily: 'explora',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.blue))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                google.extract ?? '',
                                maxLines: google.extract!.length,
                                style: const TextStyle(
                                    fontFamily: 'assistant',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          )),
    );
  }

  Future<WikiResponse?> wikiResult() async {
    var res = await Wikidart.searchQuery(
        searchController.text.isEmpty ? 'google' : searchController.text);
    WikiResponse? google;
    var pageid = res?.results?.first.pageId;

    if (pageid != null) {
      google = await Wikidart.summary(pageid);
    }
    return google;
  }

  void _createInterstitialAd() {
 initialInterstia();
    InterstitialAd.load(
        adUnitId: AbmobService.interstitialAdsId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) => interstitialAd = ad,
            onAdFailedToLoad: (LoadAdError error) => interstitialAd = null));
  }

  void _showInterstitialAds() async {
    await Future.delayed(const Duration(seconds: 15));
    if (interstitialAd != null && isInitiated == true) {
      interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
        if (kDebugMode) {
          print('show ads');
        }
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      });
      interstitialAd!.show();
      interstitialAd = null;
    }
    print("$isInitiated");
  }
}
