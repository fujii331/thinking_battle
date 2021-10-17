import 'package:flutter/material.dart';
import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';

class SkillColumn extends StatelessWidget {
  final List<int> mySkillIdsList;
  final double wordMinusSize;

  // ignore: use_key_in_widget_constructors
  const SkillColumn(
    this.mySkillIdsList,
    this.wordMinusSize,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 17,
          child: StackLabel('skills', 0),
        ),
        SkillTooltip(
          skillSettings[mySkillIdsList[0] - 1],
          true,
          wordMinusSize,
        ),
        const SizedBox(height: 4),
        SkillTooltip(
          skillSettings[mySkillIdsList[1] - 1],
          true,
          wordMinusSize,
        ),
        const SizedBox(height: 4),
        SkillTooltip(
          skillSettings[mySkillIdsList[2] - 1],
          true,
          wordMinusSize,
        ),
      ],
    );
  }
}
