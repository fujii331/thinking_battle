import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:io';
import 'package:thinking_battle/data/advertising.dart';
import 'package:thinking_battle/providers/game.provider.dart';

void showInterstitialAd(
  BuildContext context,
) async {
  if (context.read(interstitialAdProvider).state == null) {
    return;
  }
  context.read(interstitialAdProvider).state!.fullScreenContentCallback =
      FullScreenContentCallback(
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
    },
  );
  context.read(interstitialAdProvider).state!.show();
  context.read(interstitialAdProvider).state = null;
}

void createInterstitialAd(
  BuildContext context,
  int _numInterstitialLoadAttempts,
) {
  InterstitialAd.load(
    adUnitId: Platform.isAndroid
        ? androidGameInterstitalAdvid
        : iosGameInterstitalAdvid,
    // adUnitId: InterstitialAd.testAdUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        context.read(interstitialAdProvider).state = ad;
        _numInterstitialLoadAttempts = 0;
        context.read(interstitialAdProvider).state!.setImmersiveMode(true);
      },
      onAdFailedToLoad: (LoadAdError error) {
        _numInterstitialLoadAttempts += 1;
        context.read(interstitialAdProvider).state = null;
        if (_numInterstitialLoadAttempts <= 3) {
          createInterstitialAd(
            context,
            _numInterstitialLoadAttempts,
          );
        }
      },
    ),
  );
}

Future interstitialLoading(
  BuildContext context,
) async {
  int _numInterstitialLoadAttempts = 0;
  createInterstitialAd(
    context,
    _numInterstitialLoadAttempts,
  );
  for (int i = 0; i < 10; i++) {
    if (i > 2 && context.read(interstitialAdProvider).state != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}
