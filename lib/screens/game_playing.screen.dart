import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/services/common_action.service.dart';
import 'package:thinking_battle/widgets/modal/answer_modal.widget.dart';
import 'package:thinking_battle/widgets/modal/question_modal.widget.dart';
import 'package:thinking_battle/widgets/modal/time_limit.widget.dart';
import 'dart:async';
import 'dart:math';
import 'package:bubble/bubble.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/background.widget.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/widgets/modal/ready.widget.dart';
import 'package:thinking_battle/widgets/modal/rival_info.widget.dart';

import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/skills.dart';

class GamePlayingScreen extends HookWidget {
  const GamePlayingScreen({Key? key}) : super(key: key);
  static const routeName = '/game-playing';

  void nextPerson(
    ValueNotifier<DateTime> subTime,
    DateTime baseSubTime,
    ValueNotifier<int> playerId,
    int numOfPlayersValue,
  ) {
    subTime.value = baseSubTime;
    if (playerId.value != numOfPlayersValue) {
      playerId.value++;
    } else {
      playerId.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final bool precedingFlg = args[0];
    final String quizThema = args[1];

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    final DateTime myTurnTime = useProvider(myTurnTimeProvider).state;

    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;
    final bool forceQuestionFlg = useProvider(forceQuestionFlgProvider).state;
    final bool answerFailedFlg = useProvider(answerFailedFlgProvider).state;
    final bool displayQuestionResearch =
        useProvider(displayQuestionResearchProvider).state;
    final bool animationQuestionResearch =
        useProvider(animationQuestionResearchProvider).state;

    final int currentSkillPoint = useProvider(currentSkillPointProvider).state;

    final int spChargeTurn = useProvider(spChargeTurnProvider).state;

    final ValueNotifier<bool> displayFlgState = useState<bool>(false);
    final bool displayMyturnSetFlg =
        useProvider(displayMyturnSetFlgProvider).state;
    final bool displayRivalturnSetFlg =
        useProvider(displayRivalturnSetFlgProvider).state;

    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width;

    final List<DisplayContent> displayContentList =
        useProvider(displayContentListProvider).state;

    final MaterialColor rivalColor = useProvider(rivalColorProvider).state;

    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (!displayFlgState.value) {
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Ready(
                precedingFlg,
                quizThema,
              );
            },
          );

          displayFlgState.value = true;
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          context.read(bgmProvider).state = await soundEffect.loop(
            'sounds/playing.mp3',
            volume: bgmVolume,
            isNotification: true,
          );
          initializeAction(
            context,
            precedingFlg,
            context.read(allQuestionsProvider).state,
            soundEffect,
            seVolume,
          );
        } else {
          // 時間切れ判定
          if (DateFormat('ss').format(myTurnTime) == '00') {
            context.read(myTurnFlgProvider).state = false;
            await showDialog<int>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const TimeLimit();
              },
            );
          }
        }
      });
      return null;
    }, [myTurnTime]);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'テーマ：' + quizThema,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
        ),
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(0, 0, 0, 0.6),
              ),
              width: widthSetting,
              height: MediaQuery.of(context).size.height > 800 ? 800 : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: displayFlgState.value ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 30,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                soundEffect.play(
                                  'sounds/tap.mp3',
                                  isNotification: true,
                                  volume: 0.5,
                                );
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.NO_HEADER,
                                  headerAnimationLoop: false,
                                  dismissOnTouchOutside: true,
                                  dismissOnBackKeyPress: true,
                                  showCloseIcon: true,
                                  animType: AnimType.SCALE,
                                  width:
                                      MediaQuery.of(context).size.width * .86 >
                                              650
                                          ? 650
                                          : null,
                                  body: const RivalInfo(),
                                ).show();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: rivalColor,
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Image.asset(
                                    'assets/images/' +
                                        rivalInfo.imageNumber.toString() +
                                        '.png',
                                    height: 30,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Stack(
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: displayRivalturnSetFlg ? 1 : 0,
                                  child: Row(
                                    children: [
                                      const Text(
                                        '残り',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          DateFormat('ss').format(myTurnTime),
                                          style: TextStyle(
                                            color: (int.parse(DateFormat('ss')
                                                        .format(myTurnTime)) <
                                                    10)
                                                ? Colors.red.shade200
                                                : Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '秒',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: displayMyturnSetFlg ? 1 : 0,
                                  child: Text(
                                    'あいてのターン',
                                    style: TextStyle(
                                      color: Colors.green.shade300,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      currentSkillPoint.toString(),
                                      style: TextStyle(
                                        color: spChargeTurn > 0
                                            ? Colors.red.shade200
                                            : Colors.white,
                                        fontSize: 24,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'SP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white54,
                              blurRadius: 12.0,
                              spreadRadius: 0.1,
                              offset: Offset(4, 4),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              padding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                                top: 4,
                                bottom: 10,
                              ),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final DisplayContent targetContent =
                                      displayContentList[index];

                                  int displayNumber = 0;
                                  final List<Widget> skillList = [];

                                  for (int skillId in targetContent.skillIds) {
                                    if (skillId != 0 &&
                                        !(skillId == 4 &&
                                            !targetContent.myTurnFlg)) {
                                      skillList.add(
                                        _skillMessage(
                                          targetContent.specialMessage != ''
                                              ? skillId < 0
                                                  ? skillSettings[
                                                          (-1 * skillId) - 1]
                                                      .skillName
                                                  : skillSettings[skillId - 1]
                                                      .skillName
                                              : targetContent.specialMessage,
                                          targetContent.myTurnFlg,
                                          targetContent.displayList,
                                          displayNumber,
                                          skillId < 0 ? true : false,
                                        ),
                                      );
                                      displayNumber++;
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          targetContent.myTurnFlg
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end,
                                      children: [
                                        Column(children: skillList),
                                        _contentRow(
                                          context,
                                          targetContent,
                                          rivalInfo.imageNumber,
                                          rivalColor,
                                          displayNumber,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: displayContentList.length,
                              ),
                            ),
                            displayQuestionResearch
                                ? AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: animationQuestionResearch ? 1 : 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/question_research.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text(
                                '解答',
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: myTurnFlg &&
                                        !forceQuestionFlg &&
                                        !answerFailedFlg
                                    ? Colors.pink.shade600
                                    : Colors.pink.shade200,
                                textStyle: Theme.of(context).textTheme.button,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: myTurnFlg &&
                                      !forceQuestionFlg &&
                                      !answerFailedFlg
                                  ? () {
                                      soundEffect.play(
                                        'sounds/tap.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );

                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled:
                                              true, //trueにしないと、Containerのheightが反映されない
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                          ),
                                          builder: (BuildContext context) {
                                            return AnswerModal(
                                                scrollController);
                                          });
                                    }
                                  : () {},
                            ),
                            ElevatedButton(
                              child: const Text(
                                '質問',
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: myTurnFlg
                                    ? Colors.blue.shade500
                                    : Colors.blue.shade200,
                                textStyle: Theme.of(context).textTheme.button,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: myTurnFlg && !forceQuestionFlg
                                  ? () {
                                      soundEffect.play(
                                        'sounds/tap.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );

                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled:
                                              true, //trueにしないと、Containerのheightが反映されない
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                          ),
                                          builder: (BuildContext context) {
                                            return QuestionModal(
                                                scrollController);
                                          });
                                    }
                                  : () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skillMessage(
    String skillName,
    bool myTurnFlg,
    List displayList,
    int displayNumber,
    bool lineThroughFlg,
  ) {
    return displayList.length > displayNumber
        ? Padding(
            padding: const EdgeInsets.only(
              left: 6.0,
              right: 6.0,
              bottom: 3,
            ),
            child: Text(
              skillName,
              style: TextStyle(
                fontSize: 16,
                color: myTurnFlg
                    ? Colors.orange.shade200
                    : Colors.blueGrey.shade100,
                fontFamily: 'KaiseiOpti',
                decoration: lineThroughFlg ? TextDecoration.lineThrough : null,
              ),
            ),
          )
        : Container();
  }

  Widget _contentRow(
    BuildContext context,
    DisplayContent targetContent,
    int rivalImageNumber,
    MaterialColor rivalColor,
    int displayNumber,
  ) {
    return targetContent.myTurnFlg
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              targetContent.displayList.length > displayNumber + 2
                  ? _replyMessage(
                      targetContent,
                    )
                  : Container(),
              targetContent.displayList.length > displayNumber + 1
                  ? _sendMessage(
                      context,
                      targetContent,
                    )
                  : Container(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              targetContent.displayList.length > displayNumber + 1
                  ? Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: rivalColor,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Image.asset(
                              'assets/images/' +
                                  rivalImageNumber.toString() +
                                  '.png',
                            ),
                          ),
                        ),
                        _sendMessage(
                          context,
                          targetContent,
                        )
                      ],
                    )
                  : Container(),
              targetContent.displayList.length > displayNumber + 2
                  ? _replyMessage(
                      targetContent,
                    )
                  : Container(),
            ],
          );
  }

  Widget _sendMessage(
    BuildContext context,
    DisplayContent targetContent,
  ) {
    final double restrictWidth = MediaQuery.of(context).size.width * .56;
    const double fontSize = 16;
    final bool myTurnFlg = targetContent.myTurnFlg;
    final bool answerFlg = targetContent.answerFlg;
    final String message = targetContent.content;
    final List<int> skillIds = targetContent.skillIds;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      width: message.length * (fontSize + 1) > restrictWidth
          ? restrictWidth
          : null,
      child: Bubble(
        alignment: myTurnFlg ? Alignment.topRight : Alignment.topLeft,
        borderWidth: 2,
        borderColor: Colors.black,
        elevation: 2.0,
        shadowColor: Colors.grey,
        nipOffset: message.length * (fontSize + 1) > restrictWidth ? 20 : 7,
        nipWidth: 12,
        nipHeight: 8,
        nip: myTurnFlg ? BubbleNip.rightBottom : BubbleNip.leftBottom,
        color: answerFlg
            ? Colors.red.shade100
            : skillIds.contains(1)
                ? Colors.purple.shade200
                : skillIds.contains(-1)
                    ? Colors.yellow.shade200
                    : Colors.white,
        child: Text(
          skillIds.contains(1) && !myTurnFlg ? '？？？' : message,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }

  Widget _replyMessage(
    DisplayContent targetContent,
  ) {
    final List<int> skillIds = targetContent.skillIds;
    final bool myTurnFlg = targetContent.myTurnFlg;

    return Container(
      decoration: BoxDecoration(
        color: targetContent.answerFlg
            ? Colors.blue.shade200
            : skillIds.contains(4) && myTurnFlg
                ? Colors.purple.shade200
                : skillIds.contains(-4)
                    ? Colors.yellow.shade200
                    : const Color.fromRGBO(212, 234, 244, 1.0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 7.0,
          right: 7.0,
          top: 2.5,
          bottom: 5.5,
        ),
        child: Text(
          targetContent.skillIds.contains(4) && !myTurnFlg
              ? targetContent.reply == 'はい'
                  ? 'いいえ'
                  : 'はい'
              : targetContent.reply,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
