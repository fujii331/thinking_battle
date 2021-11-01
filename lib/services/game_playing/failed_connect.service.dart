import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/screens/game_finish.screen.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/services/game_playing/update_rate.service.dart';
import 'package:thinking_battle/widgets/game_playing/disconnected.widget.dart';

Future failedConnect(
  BuildContext context,
) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.ERROR,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
    body: const AttentionModal(
      topText: '外部に接続できません',
      secondText: '電波の状態をご確認ください。\n結果画面に移ります。',
    ),
  ).show();

  // レート計算
  await updateRate(
    context,
    false,
  );

  context.read(timerCancelFlgProvider).state = true;

  await Future.delayed(
    const Duration(milliseconds: 3500),
  );

  Navigator.popUntil(context, ModalRoute.withName(GamePlayingScreen.routeName));

  Navigator.of(context).pushReplacementNamed(
    GameFinishScreen.routeName,
    arguments: false,
  );
}
