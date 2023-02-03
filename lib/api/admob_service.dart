import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AbmobService {
  static String? get bannerAdsId =>
   "ca-app-pub-3900780607450933/3192254480"; //  "ca-app-pub-3940256099942544/6300978111"; 
  static String? get interstitialAdsId =>
   "ca-app-pub-3900780607450933/4313764460"; //   "ca-app-pub-3940256099942544/1033173712";// 

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad load'),
    onAdFailedToLoad: (ad, error) {
      debugPrint('Ad Faild to load: $error');
      ad.dispose();
    },
    onAdOpened: (ad) => debugPrint('ad opened'),
    onAdClosed: (ad) => debugPrint('ad closed'),
  );
}
