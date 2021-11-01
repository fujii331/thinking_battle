import 'package:flutter/material.dart';
import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';

class SkillColumn extends StatelessWidget {
  final List<int> mySkillIdsList;
  final double wordMinusSize;

  const SkillColumn({
    Key? key,
    required this.mySkillIdsList,
    required this.wordMinusSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 17,
          child: StackLabel(
            word: 'skills',
            wordMinusSize: wordMinusSize,
          ),
        ),
        SkillTooltip(
          skill: skillSettings[mySkillIdsList[0] - 1],
          profileFlg: true,
          wordMinusSize: wordMinusSize,
        ),
        const SizedBox(height: 4),
        SkillTooltip(
          skill: skillSettings[mySkillIdsList[1] - 1],
          profileFlg: true,
          wordMinusSize: wordMinusSize,
        ),
        const SizedBox(height: 4),
        SkillTooltip(
          skill: skillSettings[mySkillIdsList[2] - 1],
          profileFlg: true,
          wordMinusSize: wordMinusSize,
        ),
      ],
    );
  }
}
