import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/services/admob/reward_action.service.dart';
import 'package:thinking_battle/widgets/common/comment_modal.widget.dart';
import 'package:thinking_battle/widgets/common/loading_modal.widget.dart';

class GachaButton extends HookWidget {
  final int buttonNumber;
  final int gachaPoint;
  final int gachaCount;
  final int gachaTicket;
  final List<String> itemNumberList;
  final List<List<int>> getitemNumberList;
  final AudioCache soundEffect;
  final double seVolume;

  const GachaButton({
    Key? key,
    required this.buttonNumber,
    required this.gachaPoint,
    required this.gachaCount,
    required this.gachaTicket,
    required this.itemNumberList,
    required this.getitemNumberList,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gachaNumber = buttonNumber == 1
        ? 24
        : buttonNumber == 2
            ? 20
            : 20; // ガチャの種類が増えたら要修正
    bool remainingFlg = false;

    // 全てのガチャを手に入れていたらフラグがfalseのままになり、ボタンが押せない
    for (int i = 5; i <= gachaNumber; i++) {
      if (!itemNumberList.contains(i.toString())) {
        remainingFlg = true;
        break;
      }
    }

    final bool enableMovieGacha = gachaCount > 0;

    final bool enableGacha =
        (gachaTicket > 0 || enableMovieGacha) && remainingFlg;
    final ValueNotifier<RewardedAd?> rewardedAd = useState(null);

    return SizedBox(
      width: gachaTicket > 0 ? 150 : 140,
      height: 40,
      child: ElevatedButton(
        child: Padding(
          padding: EdgeInsets.only(top: !Platform.isAndroid ? 2 : 0),
          child: Text(
            gachaTicket > 0
                ? 'ガチャチケを使う'
                : ('動画を見る ' + gachaCount.toString() + '/5'),
            style: TextStyle(
              fontSize: gachaTicket > 0 ? 16 : 17,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary:
              enableGacha ? Colors.orange.shade600 : Colors.orange.shade200,
          padding: EdgeInsets.only(
            bottom: Platform.isAndroid ? 3 : 2,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            width: 2,
            color: Colors.orange.shade700,
          ),
        ),
        onPressed: enableGacha
            ? () async {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();

                if (gachaTicket > 0) {
                  gachaAction(
                    context,
                    getitemNumberList,
                    prefs,
                    buttonNumber,
                    itemNumberList,
                    soundEffect,
                    seVolume,
                    1,
                  );
                } else {
                  // ロード中モーダルの表示
                  showDialog<int>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const LoadingModal();
                    },
                  );
                  // 広告のロード
                  await rewardLoading(
                    context,
                    rewardedAd,
                    buttonNumber,
                  );
                  if (rewardedAd.value != null) {
                    showRewardedAd(
                      context,
                      rewardedAd,
                      getitemNumberList,
                      prefs,
                      buttonNumber,
                      itemNumberList,
                      soundEffect,
                      seVolume,
                    );
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      headerAnimationLoop: false,
                      dismissOnTouchOutside: true,
                      dismissOnBackKeyPress: true,
                      showCloseIcon: true,
                      animType: AnimType.SCALE,
                      width: MediaQuery.of(context).size.width * .86 > 550
                          ? 550
                          : null,
                      body: const CommentModal(
                        topText: '取得失敗',
                        secondText: '動画の読み込みに失敗しました。\n電波の良いところで再度お試しください。',
                        closeButtonFlg: true,
                      ),
                    ).show();
                  }
                }
              }
            : () {},
      ),
    );
  }
}
