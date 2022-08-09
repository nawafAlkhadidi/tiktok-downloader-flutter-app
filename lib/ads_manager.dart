import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static bool testMode = false;


  static String get bannerAdUnitId {
    if (testMode == true) {
      return BannerAd.testAdUnitId;
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3764698949994461/1667252300";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1571703103044065/2885703588";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

 
}
