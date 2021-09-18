import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/models/skill.model.dart';

import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';

class SettingMySkills extends HookWidget {
  final List<int> selectingSkillList;

  // ignore: use_key_in_widget_constructors
  const SettingMySkills(
    this.selectingSkillList,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final judgeFlgState = useState(true);

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
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
          Container(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 9,
            ),
            height: 70,
            child: Text(
              'スキル名を長押しすると説明が出てきます',
              style: TextStyle(
                height: 1.3,
                fontSize: 17.0,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[0],
            judgeFlgState,
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[1],
            judgeFlgState,
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[2],
            judgeFlgState,
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[3],
            judgeFlgState,
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[4],
            judgeFlgState,
          ),
          _skillRow(
            context,
            selectingSkillList,
            skillSettings[5],
            judgeFlgState,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: ElevatedButton(
              onPressed: selectingSkillList.length == 3
                  ? () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
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
              child: const Text(
                '更新',
              ),
              style: ElevatedButton.styleFrom(
                primary: selectingSkillList.length == 3
                    ? Colors.orange
                    : Colors.orange.shade200,
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
    List<int> selectingSkillList,
    Skill skill,
    ValueNotifier<bool> judgeFlgState,
  ) {
    int skillNumber = skill.id;

    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: selectingSkillList.contains(skillNumber),
            onChanged: (bool? checked) {
              if (checked!) {
                selectingSkillList.add(skillNumber);
              } else {
                selectingSkillList
                    .removeWhere((int number) => number == skillNumber);
              }
              judgeFlgState.value = !judgeFlgState.value;
            },
          ),
          SkillTooltip(skill),
        ],
      ),
    );
  }
}
