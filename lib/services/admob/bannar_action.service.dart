import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io';
import 'package:thinking_battle/data/advertising.dart';

BannerAd getBanner(int pageNumber) {
  // final BannerAdListener listener = BannerAdListener(
  //   // Called when an ad is successfully received.
  //   onAdLoaded: (Ad ad) => print('Ad loaded.'),
  //   // Called when an ad request failed.
  //   onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //     // Dispose the ad here to free resources.
  //     ad.dispose();
  //     print('Ad failed to load: $error');
  //   },
  //   // Called when an ad opens an overlay that covers the screen.
  //   onAdOpened: (Ad ad) => print('Ad opened.'),
  //   // Called when an ad removes an overlay that covers the screen.
  //   onAdClosed: (Ad ad) => print('Ad closed.'),
  //   // Called when an impression occurs on the ad.
  //   onAdImpression: (Ad ad) => print('Ad impression.'),
  // );

  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? pageNumber == 1
            ? androidResultBannerAdvid
            : androidContentListBannerAdvid
        : pageNumber == 1
            ? iosResultBannerAdvid
            : iosContentListBannerAdvid,
    // adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  myBanner.load();

  return myBanner;
}
