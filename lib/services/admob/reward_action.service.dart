import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'package:thinking_battle/data/advertising.dart';
import 'package:thinking_battle/widgets/common/comment_modal.widget.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/gacha_movie.widget.dart';

void showRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  List<List<int>> getitemNumberList,
  SharedPreferences prefs,
  int buttonNumber,
  List<String> itemNumberList,
  AudioCache soundEffect,
  double seVolume,
) {
  if (rewardAd.value == null) {
    return;
  }
  rewardAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
        body: const CommentModal(
          topText: '取得失敗',
          secondText: '報酬を取得できませんでした。\n電波の良いところで再度お試しください。',
          closeButtonFlg: true,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
    gachaAction(
      context,
      getitemNumberList,
      prefs,
      buttonNumber,
      itemNumberList,
      soundEffect,
      seVolume,
      2,
    );
  });
  rewardAd.value = null;
}

void createRewardedAd(
  ValueNotifier<RewardedAd?> rewardedAd,
  int _numRewardedLoadAttempts,
  int buttonNumber,
) {
  RewardedAd.load(
    // adUnitId: Platform.isAndroid
    //     ? buttonNumber == 1
    //         ? androidIconRewardAdvid
    //         : buttonNumber == 2
    //             ? androidThemeRewardAdvid
    //             : androidMessageRewardAdvid
    //     : buttonNumber == 1
    //         ? iosIconRewardAdvid
    //         : buttonNumber == 2
    //             ? iosThemeRewardAdvid
    //             : iosMessageRewardAdvid,
    adUnitId: RewardedAd.testAdUnitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        rewardedAd.value = ad;
        _numRewardedLoadAttempts = 0;
      },
      onAdFailedToLoad: (LoadAdError error) {
        rewardedAd.value = null;
        _numRewardedLoadAttempts += 1;
        if (_numRewardedLoadAttempts <= 3) {
          createRewardedAd(
            rewardedAd,
            _numRewardedLoadAttempts,
            buttonNumber,
          );
        }
      },
    ),
  );
}

Future rewardLoading(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardedAd,
  int buttonNumber,
) async {
  int _numRewardedLoadAttempts = 0;
  createRewardedAd(
    rewardedAd,
    _numRewardedLoadAttempts,
    buttonNumber,
  );
  for (int i = 0; i < 15; i++) {
    if (rewardedAd.value != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}

Future gachaAction(
  BuildContext context,
  List<List<int>> getitemNumberList,
  SharedPreferences prefs,
  int buttonNumber,
  List<String> itemNumberList,
  AudioCache soundEffect,
  double seVolume,
  int patternValue,
) async {
  await Future.delayed(
    const Duration(milliseconds: 200),
  );

  AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    showCloseIcon: false,
    animType: AnimType.SCALE,
    dialogBackgroundColor: Colors.black.withOpacity(0.0),
    width: MediaQuery.of(context).size.width * .86 > 330 ? 330 : null,
    body: GachaMovie(
      preScreenContext: context,
      prefs: prefs,
      buttonNumber: buttonNumber,
      getitemNumberList: getitemNumberList,
      itemNumberList: itemNumberList,
      soundEffect: soundEffect,
      seVolume: seVolume,
      patternValue: patternValue,
    ),
  ).show();
}
