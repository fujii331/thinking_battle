import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/background.widget.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/skills.dart';

class ActionedList extends HookWidget {
  const ActionedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DisplayContent> displayContentList =
        useProvider(displayContentListProvider).state;
    final List<String> correctAnswers =
        useProvider(correctAnswersProvider).state;
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;
    final MaterialColor rivalColor = useProvider(rivalColorProvider).state;

    return Stack(
      children: <Widget>[
        background(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * .75,
              width: MediaQuery.of(context).size.width * .85,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '答え：' + correctAnswers[0],
                      style: TextStyle(
                        color: Colors.yellow.shade200,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final DisplayContent targetContent =
                            displayContentList[index];

                        final List<Widget> skillList = [];

                        for (int skillId in targetContent.skillIds) {
                          if (skillId != 0) {
                            skillList.add(
                              _skillMessage(
                                targetContent.specialMessage != ''
                                    ? skillId < 0
                                        ? skillSettings[(-1 * skillId) - 1]
                                            .skillName
                                        : skillSettings[skillId - 1].skillName
                                    : targetContent.specialMessage,
                                targetContent.myTurnFlg,
                                targetContent.displayList,
                              ),
                            );
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
                                rivalColor,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: displayContentList.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _skillMessage(
    String skillName,
    bool myTurnFlg,
    List displayList,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 6.0,
        right: 6.0,
        bottom: 3,
      ),
      child: Text(
        skillName,
        style: TextStyle(
          fontSize: 16,
          color: myTurnFlg ? Colors.orange.shade200 : Colors.blueGrey.shade100,
          fontFamily: 'KaiseiOpti',
        ),
      ),
    );
  }

  Widget _contentRow(
    BuildContext context,
    DisplayContent targetContent,
    int rivalImageNumber,
    MaterialColor rivalColor,
  ) {
    return targetContent.myTurnFlg
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _replyMessage(
                targetContent,
              ),
              _sendMessage(
                context,
                targetContent,
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
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
                        'assets/images/' + rivalImageNumber.toString() + '.png',
                      ),
                    ),
                  ),
                  _sendMessage(
                    context,
                    targetContent,
                  )
                ],
              ),
              _replyMessage(
                targetContent,
              ),
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
          message,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }

  Widget _replyMessage(
    DisplayContent targetContent,
  ) {
    final List<int> skillIds = targetContent.skillIds;

    return Container(
      decoration: BoxDecoration(
        color: targetContent.answerFlg
            ? Colors.blue.shade200
            : skillIds.contains(4)
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
          targetContent.reply,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
