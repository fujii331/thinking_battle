import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/widgets/game_play_content/question_modal_content.widget.dart';

class QuestionModal extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;
  final ValueNotifier<bool> displayUpdateFlgState;

  const QuestionModal({
    Key? key,
    required this.screenContext,
    required this.scrollController,
    required this.myActionDoc,
    required this.rivalListenSubscription,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
    required this.displayUpdateFlgState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int selectQuestionId = useProvider(selectQuestionIdProvider).state;
    final List<Question> selectableQuestions =
        useProvider(selectableQuestionsProvider).state;
    final List<int> selectSkillIds = useProvider(selectSkillIdsProvider).state;
    final bool forceQuestionFlg = useProvider(forceQuestionFlgProvider).state;
    final ValueNotifier<bool> changeFlgState = useState(false);

    return QuestionModalContent(
      screenContext: screenContext,
      scrollController: scrollController,
      myActionDoc: myActionDoc,
      rivalListenSubscription: rivalListenSubscription,
      soundEffect: soundEffect,
      seVolume: seVolume,
      myTurnFlg: myTurnFlg,
      selectQuestionId: selectQuestionId,
      selectableQuestions: selectableQuestions,
      selectSkillIds: selectSkillIds,
      forceQuestionFlg: forceQuestionFlg,
      changeFlgState: changeFlgState,
      displayUpdateFlgState: displayUpdateFlgState,
    );
  }
}
