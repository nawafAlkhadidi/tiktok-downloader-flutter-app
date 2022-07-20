import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static bool testMode = false;

  late InterstitialAd? interstitialAd;
  int numInterstitialLoadAttempts = 0;



  static String get bannerAdUnitId {
    if (testMode == true) {
      return BannerAd.testAdUnitId;
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3764698949994461~3266170783";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1571703103044065/2885703588";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  // static String get interstitialAdUnitId {
  //   if (testMode == true) {
  //     return InterstitialAd.testAdUnitId;
  //   } else if (Platform.isAndroid) {
  //     return "ca-app-pub-1571703103044065/4157175333";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-1571703103044065/2885703588";
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }
}
