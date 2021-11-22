import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/services/admob/bannar_action.service.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';

import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/data/skills.dart';

class ActionedList extends HookWidget {
  const ActionedList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DisplayContent> displayContentList =
        useProvider(displayContentListProvider).state;
    final List<String> correctAnswers =
        useProvider(correctAnswersProvider).state;
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;
    final List colorList = returnCardColorList(rivalInfo.cardNumber);

    final BannerAd bannerAd = getBanner(2);

    final bool widthOk = MediaQuery.of(context).size.width > 350;
    final double fontSize = widthOk ? 16 : 14;
    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 585
        : MediaQuery.of(context).size.width * 0.9;

    return Stack(
      children: <Widget>[
        background(),
        Padding(
          padding: const EdgeInsets.only(top: 45),
          child: Center(
            child: Column(
              children: [
                Text(
                  '答え：' + correctAnswers[0],
                  style: TextStyle(
                    color: Colors.yellow.shade200,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: bannerAd),
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SizedBox(
                    width: widthSetting,
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
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 8,
                              left: 8,
                              bottom: 10,
                              top: 4,
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 0,
                              ),
                              itemBuilder: (context, index) {
                                final DisplayContent targetContent =
                                    displayContentList[index];

                                final List<Widget> skillList = [];

                                Widget messageWidget = Container();

                                if (targetContent.messageId != 0) {
                                  messageWidget = _message(targetContent);
                                }

                                for (int skillId in targetContent.skillIds) {
                                  if (![0, 108, -108].contains(skillId)) {
                                    skillList.add(
                                      _skillMessage(
                                        targetContent.specialMessage != '' &&
                                                (skillId == 5 || skillId == 7)
                                            ? targetContent.specialMessage
                                            : skillId < 0
                                                ? skillSettings[
                                                        (-1 * skillId) - 1]
                                                    .skillName
                                                : skillSettings[skillId - 1]
                                                    .skillName,
                                        targetContent.myTurnFlg,
                                        targetContent.displayList,
                                        skillId < 0 ? true : false,
                                        fontSize,
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
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child:
                                                  Column(children: skillList),
                                            )
                                          : Container(),
                                      _contentRow(
                                        context,
                                        targetContent,
                                        rivalInfo.imageNumber,
                                        colorList,
                                        fontSize,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: displayContentList.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _message(
    DisplayContent targetContent,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 35.0,
        bottom: 10,
      ),
      child: Bubble(
        alignment:
            targetContent.myTurnFlg ? Alignment.topRight : Alignment.topLeft,
        borderWidth: 1,
        borderColor: Colors.black,
        nipOffset: 14,
        nip: targetContent.myTurnFlg
            ? BubbleNip.rightBottom
            : BubbleNip.leftBottom,
        color: Colors.grey.shade700,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.5),
          child: Text(
            messageSettings[targetContent.messageId - 1].message,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _skillMessage(
    String skillName,
    bool myTurnFlg,
    List displayList,
    bool lineThroughFlg,
    double fontSize,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 12.0,
        bottom: 4,
      ),
      child: Text(
        skillName,
        textAlign: myTurnFlg ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontSize: fontSize,
          color: myTurnFlg ? Colors.orange.shade200 : Colors.blueGrey.shade100,
          fontFamily: 'KaiseiOpti',
          fontWeight: FontWeight.bold,
          decoration: lineThroughFlg ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }

  Widget _contentRow(
    BuildContext context,
    DisplayContent targetContent,
    int rivalImageNumber,
    List colorList,
    double fontSize,
  ) {
    return targetContent.myTurnFlg
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _replyMessage(
                targetContent,
                fontSize,
              ),
              _sendMessage(
                context,
                targetContent,
                fontSize,
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              const SizedBox(width: 5),
              _sendMessage(
                context,
                targetContent,
                fontSize,
              ),
              _replyMessage(
                targetContent,
                fontSize,
              ),
            ],
          );
  }

  Widget _sendMessage(
    BuildContext context,
    DisplayContent targetContent,
    double fontSize,
  ) {
    final bool myTurnFlg = targetContent.myTurnFlg;
    final double restrictWidth = myTurnFlg
        ? MediaQuery.of(context).size.width * .56
        : MediaQuery.of(context).size.width * .47;
    final bool answerFlg = targetContent.answerFlg;
    final String message = targetContent.content;
    final List<int> skillIds = targetContent.skillIds;

    return SizedBox(
      width: message.length * (fontSize + 1) > restrictWidth
          ? restrictWidth
          : null,
      child: Bubble(
        alignment: myTurnFlg ? Alignment.topRight : Alignment.topLeft,
        borderWidth: 2,
        borderColor: Colors.black,
        nipOffset: message.length * (fontSize + 1) > restrictWidth ? 20 : 14,
        nip: myTurnFlg ? BubbleNip.rightBottom : BubbleNip.leftBottom,
        color: answerFlg
            ? Colors.red.shade100
            : skillIds.contains(1)
                ? Colors.purple.shade200
                : skillIds.contains(-1)
                    ? Colors.yellow.shade200
                    : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.5),
          child: Text(
            message,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ),
    );
  }

  Widget _replyMessage(
    DisplayContent targetContent,
    double fontSize,
  ) {
    final List<int> skillIds = targetContent.skillIds;

    return Container(
      decoration: BoxDecoration(
        color: targetContent.answerFlg
            ? Colors.blue.shade200
            : skillIds.contains(4) || skillIds.contains(108)
                ? Colors.purple.shade200
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
          left: 6,
          right: 6,
          top: 1.5,
          bottom: 4.5,
        ),
        child: Text(
          targetContent.reply,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
