import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_play_content/answer_modal_content.widget.dart';

class AnswerModal extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;

  const AnswerModal({
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
    final String inputAnswer = useProvider(inputAnswerProvider).state;

    return AnswerModalContent(
      screenContext: screenContext,
      scrollController: scrollController,
      myActionDoc: myActionDoc,
      rivalListenSubscription: rivalListenSubscription,
      soundEffect: soundEffect,
      seVolume: seVolume,
      myTurnFlg: myTurnFlg,
      inputAnswer: inputAnswer,
    );
  }
}
