import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_play_content/bottom_action_buttons_content.widget.dart';

class BottomActionButtons extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;

  const BottomActionButtons({
    Key? key,
    required this.screenContext,
    required this.scrollController,
    required this.myActionDoc,
    required this.rivalListenSubscription,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool forceQuestionFlg = useProvider(forceQuestionFlgProvider).state;
    final bool answerFailedFlg = useProvider(answerFailedFlgProvider).state;

    return BottomActionButtonsContent(
      screenContext: context,
      scrollController: scrollController,
      myActionDoc: myActionDoc,
      rivalListenSubscription: rivalListenSubscription,
      soundEffect: soundEffect,
      seVolume: seVolume,
      myTurnFlg: myTurnFlg,
      forceQuestionFlg: forceQuestionFlg,
      answerFailedFlg: answerFailedFlg,
    );
  }
}
