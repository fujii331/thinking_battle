import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/providers/game.provider.dart';

void timeStart(
  BuildContext context,
  DateTime recoveryTime,
  int lifePoint,
  bool timerCancelFlg,
  bool myTurnFlg,
  DateTime myTurnTime,
) {
  final AudioCache soundEffect = useProvider(soundEffectProvider).state;
  final double seVolume = useProvider(seVolumeProvider).state;

  Timer.periodic(
    const Duration(seconds: 1),
    (Timer timer) async {
      if (lifePoint < 5) {
        // context.read(recoveryTimeProvider).state =
        recoveryTime.add(
          const Duration(
            seconds: -1,
          ),
        );

        if (DateFormat('mm:ss').format(recoveryTime) == '00:00') {
          context.read(lifePointProvider).state = lifePoint + 1;
          context.read(recoveryTimeProvider).state =
              DateTime(2020, 1, 1, 1, 15);
        }
      }

      if (myTurnFlg) {
        // context.read(recoveryTimeProvider).state =
        myTurnTime.add(
          const Duration(
            seconds: -1,
          ),
        );
      }

      if (timer.isActive && timerCancelFlg) {
        timer.cancel();
      }
    },
  );
}
