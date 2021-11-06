import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/data/tutorial_widget.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/models/skill.model.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_page.screen.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_bottom_modal_comment.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_game_playing.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_game_playing_comment.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_question_modal.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_question_modal_red_frame.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_red_frame.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_skill_modal.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_skill_modal_red_frame.widget.dart';

class SkillListModal extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const SkillListModal({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> skillButtonList = [];

    const PlayerInfo rivalInfo = PlayerInfo(
      name: 'チュートリくん',
      rate: 1000.0,
      imageNumber: 1,
      cardNumber: 1,
      matchedCount: 0,
      continuousWinCount: 0,
      skillList: [1, 2, 3],
    );

    const PlayerInfo playerInfo = PlayerInfo(
      name: 'テストくん',
      rate: 1000.0,
      imageNumber: 2,
      cardNumber: 2,
      matchedCount: 0,
      continuousWinCount: 0,
      skillList: [1, 2, 3],
    );

    final gotSkillTutorialList = skillTutorialList(context);

    for (int i = 0; i < skillSettings.length; i++) {
      final Skill skillSetting = skillSettings[i];
      final List<Widget> skillTutorialWidget = gotSkillTutorialList[i];

      skillButtonList.add(
        _skillButton(
          context,
          skillSetting.skillName,
          skillTutorialWidget,
          soundEffect,
          seVolume,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Text(
              'スキルを選択',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Column(
            children: skillButtonList,
          ),
        ],
      ),
    );
  }

  Widget _skillButton(
    BuildContext context,
    String text,
    List<Widget> childrenWidget,
    AudioCache soundEffect,
    double seVolume,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        onTap: () async {
          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );

          Navigator.of(context).pushNamed(
            TutorialPageScreen.routeName,
            arguments: [
              text,
              childrenWidget,
            ],
          );
        },
        child: Container(
          height: 40,
          width: 125,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade100,
              ],
              stops: const [
                0.2,
                0.7,
              ],
            ),
            border: Border.all(
              color: Colors.grey,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
