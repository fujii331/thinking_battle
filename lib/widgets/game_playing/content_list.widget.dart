import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';

class ContentList extends HookWidget {
  final ScrollController scrollController;
  final PlayerInfo rivalInfo;

  const ContentList({
    Key? key,
    required this.scrollController,
    required this.rivalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DisplayContent> displayContentList =
        useProvider(displayContentListProvider).state;
    final int displayQuestionResearch =
        useProvider(displayQuestionResearchProvider).state;
    final bool animationQuestionResearch =
        useProvider(animationQuestionResearchProvider).state;

    final List colorList = returnCardColorList(rivalInfo.cardNumber);

    return SizedBox(
      height: MediaQuery.of(context).size.height - 260,
      width: MediaQuery.of(context).size.width * .9,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/background/content_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade700.withOpacity(0.80),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade800.withOpacity(0.5),
                  blurRadius: 3.0,
                  offset: const Offset(5, 5),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 4,
              bottom: 10,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                final DisplayContent targetContent = displayContentList[index];

                int displayNumber = 0;
                final List<Widget> skillList = [];
                Widget messageWidget = Container();

                if (targetContent.messageId != 0) {
                  displayNumber++;
                  messageWidget = _message(targetContent);
                }

                for (int skillId in targetContent.skillIds) {
                  // スキルがない場合、またはトラップを仕掛けられた場合はスキルを表示しない
                  if (![0, 108, -108].contains(skillId) &&
                      !((skillId == 4 || skillId == 8) &&
                          !targetContent.myTurnFlg)) {
                    displayNumber++;

                    skillList.add(
                      _skillMessage(
                        targetContent.specialMessage != '' &&
                                (skillId == 5 || skillId == 7)
                            ? targetContent.specialMessage
                            : skillId < 0
                                ? skillSettings[(-1 * skillId) - 1].skillName
                                : skillSettings[skillId - 1].skillName,
                        targetContent.myTurnFlg,
                        targetContent.displayList,
                        displayNumber,
                        skillId < 0 ? true : false,
                      ),
                    );
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: skillList.isNotEmpty ? 2 : 10,
                    left: 2,
                    right: 2,
                  ),
                  child: Column(
                    crossAxisAlignment: targetContent.myTurnFlg
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      messageWidget,
                      skillList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Column(children: skillList),
                            )
                          : Container(),
                      _contentRow(
                        context,
                        targetContent,
                        rivalInfo.imageNumber,
                        displayNumber,
                        colorList,
                      ),
                    ],
                  ),
                );
              },
              itemCount: displayContentList.length,
            ),
          ),
          displayQuestionResearch != 0
              ? AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: animationQuestionResearch ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/game/' +
                            (displayQuestionResearch == 1
                                ? 'question_research'
                                : 'question_click') +
                            '.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _message(
    DisplayContent targetContent,
  ) {
    return targetContent.displayList.isNotEmpty
        ? Container(
            height: 43,
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 36.0,
              right: 4.0,
              bottom: 10,
            ),
            child: Bubble(
              alignment: targetContent.myTurnFlg
                  ? Alignment.topRight
                  : Alignment.topLeft,
              borderWidth: 1,
              borderColor: Colors.black,
              elevation: 2.0,
              shadowColor: Colors.grey,
              nipOffset: 10,
              nipWidth: 12,
              nipHeight: 8,
              nip: targetContent.myTurnFlg
                  ? BubbleNip.rightBottom
                  : BubbleNip.leftBottom,
              color: Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.5),
                child: Text(
                  messageSettings[targetContent.messageId - 1].message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _skillMessage(
    String skillName,
    bool myTurnFlg,
    List displayList,
    int displayNumber,
    bool lineThroughFlg,
  ) {
    return displayList.length >= displayNumber
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 38.0,
              right: 12.0,
              bottom: 4,
            ),
            child: Text(
              skillName,
              textAlign: myTurnFlg ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: myTurnFlg
                    ? Colors.orange.shade200
                    : Colors.blueGrey.shade100,
                fontFamily: 'KaiseiOpti',
                fontWeight: FontWeight.bold,
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
    int displayNumber,
    List colorList,
  ) {
    return targetContent.myTurnFlg
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              targetContent.displayList.length >= displayNumber + 2
                  ? _replyMessage(
                      targetContent,
                    )
                  : Container(),
              targetContent.displayList.length >= displayNumber + 1
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
              targetContent.displayList.length >= displayNumber + 1
                  ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                              colors: colorList[0][0],
                              stops: const [
                                0.2,
                                0.6,
                                0.9,
                              ],
                            ),
                            border: Border.all(
                              color: colorList[0][1],
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/characters/' +
                                rivalImageNumber.toString() +
                                '.png',
                          ),
                        ),
                        const SizedBox(width: 3),
                        _sendMessage(
                          context,
                          targetContent,
                        )
                      ],
                    )
                  : Container(),
              targetContent.displayList.length >= displayNumber + 2
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
    final bool myTurnFlg = targetContent.myTurnFlg;

    final double restrictWidth = myTurnFlg
        ? MediaQuery.of(context).size.width * .56
        : MediaQuery.of(context).size.width * .47;
    const double fontSize = 16;
    final bool answerFlg = targetContent.answerFlg;
    final String message = targetContent.content;
    final List<int> skillIds = targetContent.skillIds;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      width: message.length * (fontSize + 1) > restrictWidth &&
              !(skillIds.contains(1) && !myTurnFlg)
          ? restrictWidth
          : null,
      child: Bubble(
        alignment: myTurnFlg ? Alignment.topRight : Alignment.topLeft,
        borderWidth: 2,
        borderColor: Colors.black,
        elevation: 2.0,
        shadowColor: Colors.grey,
        nipOffset: message.length * (fontSize + 1) > restrictWidth ? 23 : 14,
        nipWidth: 12,
        nipHeight: 8,
        nip: myTurnFlg ? BubbleNip.rightBottom : BubbleNip.leftBottom,
        color: answerFlg
            ? Colors.red.shade100
            : skillIds.contains(1)
                ? Colors.purple.shade100
                : skillIds.contains(-1)
                    ? Colors.yellow.shade200
                    : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.5),
          child: Text(
            skillIds.contains(1) && !myTurnFlg ? ' ？？？' : message,
            style: const TextStyle(fontSize: fontSize),
          ),
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
            : (skillIds.contains(4) && myTurnFlg) ||
                    (skillIds.contains(108) && !myTurnFlg)
                ? Colors.purple.shade100
                : skillIds.contains(-4) || skillIds.contains(-108)
                    ? Colors.yellow.shade200
                    : const Color.fromRGBO(212, 234, 244, 1.0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
          width: 2,
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
          (skillIds.contains(4) && !myTurnFlg) ||
                  (skillIds.contains(108) && myTurnFlg)
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
