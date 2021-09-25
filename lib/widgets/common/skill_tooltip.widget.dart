import 'package:flutter/material.dart';

import 'package:thinking_battle/models/skill.model.dart';

class SkillTooltip extends StatelessWidget {
  final Skill skill;
  final Color textColor;
  final double fontSize;

  // ignore: use_key_in_widget_constructors
  const SkillTooltip(
    this.skill,
    this.textColor,
    this.fontSize,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Tooltip(
        message: skill.skillExplanation,
        child: Text(
          skill.skillName,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey.shade900,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        excludeFromSemantics: true,
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 7,
          bottom: 9,
        ),
        preferBelow: false,
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        showDuration: const Duration(seconds: 100),
        // waitDuration: const Duration(milliseconds: 1),
      ),
    );
  }
}
