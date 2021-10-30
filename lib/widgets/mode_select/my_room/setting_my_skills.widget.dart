import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/models/skill.model.dart';

import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';

class SettingMySkills extends HookWidget {
  final List<int> selectingSkillList;
  final AudioCache soundEffect;
  final double seVolume;

  const SettingMySkills({
    Key? key,
    required this.selectingSkillList,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final judgeFlgState = useState(true);
    final List<String> settableSkillsList =
        useProvider(settableSkillsListProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 23,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 12,
            ),
            child: Text(
              '3つのスキルを選択',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'スキル名を長押しすると説明が表示されます',
            style: TextStyle(
              height: 1.3,
              fontSize: 17.0,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 15),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[0],
            judgeFlgState,
            settableSkillsList.contains('1'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[1],
            judgeFlgState,
            settableSkillsList.contains('2'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[2],
            judgeFlgState,
            settableSkillsList.contains('3'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[3],
            judgeFlgState,
            settableSkillsList.contains('4'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[4],
            judgeFlgState,
            settableSkillsList.contains('5'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[5],
            judgeFlgState,
            settableSkillsList.contains('6'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[6],
            judgeFlgState,
            settableSkillsList.contains('7'),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[7],
            judgeFlgState,
            settableSkillsList.contains('8'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: SizedBox(
              width: 90,
              height: 40,
              child: ElevatedButton(
                onPressed: selectingSkillList.length == 3
                    ? () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        selectingSkillList.sort();
                        soundEffect.play(
                          'sounds/change.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        // スキル
                        context.read(mySkillIdsListProvider).state =
                            selectingSkillList;
                        prefs.setStringList(
                            'skillList',
                            selectingSkillList
                                .map((skill) => skill.toString())
                                .toList());
                        Navigator.pop(context);
                      }
                    : () {},
                child: const Text('更新'),
                style: ElevatedButton.styleFrom(
                  primary: selectingSkillList.length == 3
                      ? Colors.orange
                      : Colors.orange.shade200,
                  padding: const EdgeInsets.only(
                    bottom: 3,
                  ),
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    width: 2,
                    color: Colors.orange.shade600,
                  ),
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
    List<int> selectingSkillList,
    Skill skill,
    ValueNotifier<bool> judgeFlgState,
    bool enableCheck,
  ) {
    int skillNumber = skill.id;

    return SizedBox(
      height: 39,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              enableCheck
                  ? Checkbox(
                      value: selectingSkillList.contains(skillNumber),
                      onChanged: (bool? checked) {
                        if (checked!) {
                          selectingSkillList.add(skillNumber);
                        } else {
                          selectingSkillList.removeWhere(
                              (int number) => number == skillNumber);
                        }
                        judgeFlgState.value = !judgeFlgState.value;
                      },
                    )
                  : Container(
                      width: 48,
                      padding: const EdgeInsets.only(
                        left: 9.3,
                        top: 13,
                      ),
                      height: 43,
                      child: Text(
                        '未入手',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ),
            ],
          ),
          SkillTooltip(
            skill: skill,
            profileFlg: false,
            wordMinusSize: 0,
          ),
        ],
      ),
    );
  }
}
