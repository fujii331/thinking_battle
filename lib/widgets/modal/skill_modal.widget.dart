import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/skill.model.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/skills.dart';

class SkillModal extends HookWidget {
  final List<int> selectSkillIdsList;

  // ignore: use_key_in_widget_constructors
  const SkillModal(
    this.selectSkillIdsList,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<int> mySkillIdsList = useProvider(mySkillIdsListProvider).state;
    final int currentSkillPoint = useProvider(currentSkillPointProvider).state;

    int sumSP = 0;

    // いらないかも
    // for (var selectSkillId in selectSkillIdsList) {
    //   sumSP += skillSettings[selectSkillId - 1].skillPoint;
    // }

    final remainingSPState = useState(currentSkillPoint - sumSP);

    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      width: MediaQuery.of(context).size.width * 0.9 > 600.0
          ? 600.0
          : MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            iconSize: 28,
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              soundEffect.play(
                'sounds/cancel.mp3',
                isNotification: true,
                volume: seVolume,
              );
              Navigator.pop(context);
            },
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 9,
            ),
            height: 90,
            child: const Text(
              '使うスキルを選んでセット',
              style: TextStyle(
                height: 1.3,
                fontSize: 17.0,
                color: Colors.black,
              ),
            ),
          ),
          _skillRow(
            context,
            selectSkillIdsList,
            skillSettings[mySkillIdsList[0] - 1],
            remainingSPState,
          ),
          _skillRow(
            context,
            selectSkillIdsList,
            skillSettings[mySkillIdsList[1] - 1],
            remainingSPState,
          ),
          _skillRow(
            context,
            selectSkillIdsList,
            skillSettings[mySkillIdsList[2] - 1],
            remainingSPState,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: ElevatedButton(
              onPressed: selectSkillIdsList.isNotEmpty
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      // スキル
                      context.read(selectSkillIdsProvider).state =
                          selectSkillIdsList;

                      Navigator.pop(context);
                    }
                  : () {},
              child: const Text(
                'セット',
              ),
              style: ElevatedButton.styleFrom(
                primary: selectSkillIdsList.isNotEmpty
                    ? Colors.green.shade100
                    : Colors.green.shade400,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillRow(
    BuildContext context,
    List<int> selectSkillIdsList,
    Skill skill,
    ValueNotifier<int> remainingSPState,
  ) {
    int skillNumber = skill.id;
    int skillPoint = skill.skillPoint;

    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          remainingSPState.value >= skillPoint
              ? Checkbox(
                  value: selectSkillIdsList.contains(skillNumber),
                  onChanged: (bool? checked) {
                    if (checked!) {
                      selectSkillIdsList.add(skillNumber);
                      remainingSPState.value -= skillPoint;
                    } else {
                      selectSkillIdsList
                          .removeWhere((int number) => number == skillNumber);
                      remainingSPState.value += skillPoint;
                    }
                  },
                )
              : Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'SP×',
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 10.0,
                        color: Colors.red.shade100,
                      ),
                    ),
                  ],
                ),
          Tooltip(
            message: skill.skillExplanation,
            child: Text(
              skill.skillName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            height: 50,
            excludeFromSemantics: true,
            padding: const EdgeInsets.all(8.0),
            preferBelow: false,
            textStyle: const TextStyle(
              fontSize: 18,
            ),
            showDuration: const Duration(milliseconds: 1),
            waitDuration: const Duration(milliseconds: 1),
          ),
        ],
      ),
    );
  }
}
