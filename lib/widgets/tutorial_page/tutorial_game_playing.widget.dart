import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/widgets/game_play_content/bottom_action_buttons_content.widget.dart';
import 'package:thinking_battle/widgets/game_play_content/content_list_content.widget.dart';
import 'package:thinking_battle/widgets/game_play_content/top_row_content.widget.dart';

class TutorialGamePlaying extends HookWidget {
  final PlayerInfo rivalInfo;
  final bool myTurnFlg;
  final int currentSkillPoint;
  final int spChargeTurn;
  final bool displayMyturnSetFlg;
  final bool displayRivalturnSetFlg;
  final List<DisplayContent> displayContentList;
  final int displayQuestionResearch;
  final bool forceQuestionFlg;
  final bool answerFailedFlg;
  final int afterMessageTime;
  final int selectMessageId;

  const TutorialGamePlaying({
    Key? key,
    required this.rivalInfo,
    required this.myTurnFlg,
    required this.currentSkillPoint,
    required this.spChargeTurn,
    required this.displayMyturnSetFlg,
    required this.displayRivalturnSetFlg,
    required this.displayContentList,
    required this.displayQuestionResearch,
    required this.forceQuestionFlg,
    required this.answerFailedFlg,
    required this.afterMessageTime,
    required this.selectMessageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width;

    final List rivalColorList = returnCardColorList(rivalInfo.cardNumber);
    final AudioCache soundEffect = AudioCache();
    const double seVolume = 0;
    final scrollController = useScrollController();
    const DocumentReference<Map<String, dynamic>>? myActionDoc = null;
    const StreamSubscription<DocumentSnapshot>? rivalListenSubscription = null;

    return Center(
      child: SizedBox(
        width: widthSetting,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 15,
            bottom: 20,
          ),
          child: Column(
            children: [
              TopRowContent(
                soundEffect: soundEffect,
                seVolume: seVolume,
                rivalInfo: rivalInfo,
                myTurnTime: 30,
                myTurnFlg: myTurnFlg,
                currentSkillPoint: currentSkillPoint,
                spChargeTurn: spChargeTurn,
                displayMyturnSetFlg: displayMyturnSetFlg,
                displayRivalturnSetFlg: displayRivalturnSetFlg,
                colorList: rivalColorList,
                afterMessageTime: afterMessageTime,
                selectMessageId: selectMessageId,
                initialTutorialFlg: false,
              ),
              const SizedBox(height: 15),
              ContentListContent(
                scrollController: scrollController,
                rivalInfo: rivalInfo,
                displayContentList: displayContentList,
                displayQuestionResearch: displayQuestionResearch,
                animationQuestionResearch: true,
                rivalColorList: rivalColorList,
                contentHeight: MediaQuery.of(context).size.height - 290,
              ),
              const SizedBox(height: 20),
              BottomActionButtonsContent(
                screenContext: context,
                scrollController: scrollController,
                myActionDoc: myActionDoc,
                rivalListenSubscription: rivalListenSubscription,
                soundEffect: soundEffect,
                seVolume: seVolume,
                myTurnFlg: myTurnFlg,
                forceQuestionFlg: forceQuestionFlg,
                answerFailedFlg: answerFailedFlg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
