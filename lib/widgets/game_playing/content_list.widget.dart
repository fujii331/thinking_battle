import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';

class ContentList extends StatelessWidget {
  final ScrollController scrollController;

  // ignore: use_key_in_widget_constructors
  const ContentList(
    this.scrollController,
  );

  @override
  Widget build(BuildContext context) {
    final List<DisplayContent> displayContentList =
        useProvider(displayContentListProvider).state;
    final bool displayQuestionResearch =
        useProvider(displayQuestionResearchProvider).state;
    final bool animationQuestionResearch =
        useProvider(animationQuestionResearchProvider).state;
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    return Container(
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
                final DisplayContent targetContent = displayContentList[index];

                int displayNumber = 0;
                final List<Widget> skillList = [];

                for (int skillId in targetContent.skillIds) {
                  if (skillId != 0 &&
                      !(skillId == 4 && !targetContent.myTurnFlg)) {
                    skillList.add(
                      _skillMessage(
                        targetContent.specialMessage != ''
                            ? skillId < 0
                                ? skillSettings[(-1 * skillId) - 1].skillName
                                : skillSettings[skillId - 1].skillName
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
                    crossAxisAlignment: targetContent.myTurnFlg
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Column(children: skillList),
                      _contentRow(
                        context,
                        targetContent,
                        rivalInfo.imageNumber,
                        rivalInfo.color,
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
                        image:
                            AssetImage('assets/images/question_research.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
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
