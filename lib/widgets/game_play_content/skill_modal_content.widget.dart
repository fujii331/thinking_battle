import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/skill.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';

class SkillModalContent extends HookWidget {
  final ValueNotifier<bool> changeFlgState;
  final AudioCache soundEffect;
  final double seVolume;
  final List<int> selectSkillIdsList;
  final List<int> mySkillIdsList;
  final int currentSkillPoint;

  const SkillModalContent({
    Key? key,
    required this.changeFlgState,
    required this.soundEffect,
    required this.seVolume,
    required this.selectSkillIdsList,
    required this.mySkillIdsList,
    required this.currentSkillPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int sumSP = 0;

    for (var selectSkillId in selectSkillIdsList) {
      sumSP += skillSettings[selectSkillId - 1].skillPoint;
    }

    final remainingSPState = useState(currentSkillPoint - sumSP);

    final selectSkillIdsState = useState([...selectSkillIdsList]);

    final double paddingWidth = MediaQuery.of(context).size.width > 450.0
        ? (MediaQuery.of(context).size.width - 450) / 2
        : 5;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: paddingWidth,
          right: paddingWidth,
          bottom: 25,
        ),
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
                  padding: EdgeInsets.only(
                    bottom: Platform.isAndroid ? 3 : 1,
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
            Platform.isAndroid ? Container() : const SizedBox(height: 8),
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
                      padding: EdgeInsets.only(
                        left: Platform.isAndroid ? 13.5 : 12.8,
                        top: Platform.isAndroid ? 1 : 0,
                        bottom: Platform.isAndroid ? 0 : 0.5,
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
            padding: const EdgeInsets.only(top: 10),
            child: SkillTooltip(
              skill: skill,
              profileFlg: false,
              wordMinusSize: 0,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 13,
              ),
              child: Text(
                'SP ' + skill.skillPoint.toString(),
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
