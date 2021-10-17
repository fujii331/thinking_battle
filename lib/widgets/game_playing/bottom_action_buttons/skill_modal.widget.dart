import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/skill.model.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';

class SkillModal extends HookWidget {
  final ValueNotifier<bool> changeFlgState;

  // ignore: use_key_in_widget_constructors
  const SkillModal(
    this.changeFlgState,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = context.read(soundEffectProvider).state;
    final double seVolume = context.read(seVolumeProvider).state;
    final List<int> selectSkillIdsList =
        context.read(selectSkillIdsProvider).state;

    final List<int> mySkillIdsList = context.read(mySkillIdsListProvider).state;
    final int currentSkillPoint = context.read(currentSkillPointProvider).state;

    int sumSP = 0;

    for (var selectSkillId in selectSkillIdsList) {
      sumSP += skillSettings[selectSkillId - 1].skillPoint;
    }

    final remainingSPState = useState(currentSkillPoint - sumSP);

    final selectSkillIdsState = useState([...selectSkillIdsList]);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          bottom: 25,
        ),
        width: MediaQuery.of(context).size.width * 0.8 > 600.0
            ? 600.0
            : MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                const Spacer(),
                IconButton(
                  iconSize: 28,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const Text(
              '使うスキルを選んでセット',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                children: [
                  _skillRow(
                    context,
                    selectSkillIdsList,
                    selectSkillIdsState,
                    skillSettings[mySkillIdsList[0] - 1],
                    remainingSPState,
                  ),
                  _skillRow(
                    context,
                    selectSkillIdsList,
                    selectSkillIdsState,
                    skillSettings[mySkillIdsList[1] - 1],
                    remainingSPState,
                  ),
                  _skillRow(
                    context,
                    selectSkillIdsList,
                    selectSkillIdsState,
                    skillSettings[mySkillIdsList[2] - 1],
                    remainingSPState,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 80,
              height: 40,
              child: ElevatedButton(
                child: const Text('セット'),
                style: ElevatedButton.styleFrom(
                  primary: selectSkillIdsList.isNotEmpty ||
                          selectSkillIdsState.value.isNotEmpty
                      ? Colors.green.shade600
                      : Colors.green.shade200,
                  textStyle: Theme.of(context).textTheme.button,
                  padding: const EdgeInsets.only(
                    bottom: 3,
                  ),
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    width: 2,
                    color: Colors.green.shade700,
                  ),
                ),
                onPressed: selectSkillIdsList.isNotEmpty ||
                        selectSkillIdsState.value.isNotEmpty
                    ? () {
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        selectSkillIdsState.value.sort((a, b) => a - b);
                        // スキル
                        context.read(selectSkillIdsProvider).state =
                            selectSkillIdsState.value;

                        changeFlgState.value = !changeFlgState.value;

                        Navigator.pop(context);
                      }
                    : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skillRow(
    BuildContext context,
    List<int> selectedSkillIdsList,
    ValueNotifier<List<int>> selectSkillIdsList,
    Skill skill,
    ValueNotifier<int> remainingSPState,
  ) {
    int skillNumber = skill.id;
    int skillPoint = skill.skillPoint;

    final bool enableCheck = remainingSPState.value >= skillPoint ||
        selectedSkillIdsList.contains(skillNumber) ||
        selectSkillIdsList.value.contains(skillNumber);

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Checkbox(
                value: enableCheck
                    ? selectSkillIdsList.value.contains(skillNumber)
                    : false,
                onChanged: enableCheck
                    ? (bool? checked) {
                        if (checked!) {
                          selectSkillIdsList.value.add(skillNumber);
                          remainingSPState.value -= skillPoint;
                        } else {
                          selectSkillIdsList.value.removeWhere(
                              (int number) => number == skillNumber);
                          remainingSPState.value += skillPoint;
                        }
                      }
                    : null,
              ),
              enableCheck
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 13.5,
                        top: 1,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 35,
                            child: Text(
                              '×',
                              style: TextStyle(
                                height: 1.3,
                                fontSize: 33,
                                color: Colors.orange.shade300,
                              ),
                            ),
                          ),
                          Text(
                            'SP×',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: SkillTooltip(
              skill,
              false,
              0,
            ),
          ),
        ],
      ),
    );
  }
}
