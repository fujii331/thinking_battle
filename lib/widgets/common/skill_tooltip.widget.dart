import 'package:flutter/material.dart';

import 'package:thinking_battle/models/skill.model.dart';

class SkillTooltip extends StatelessWidget {
  final Skill skill;

  // ignore: use_key_in_widget_constructors
  const SkillTooltip(
    this.skill,
  );

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: skill.skillExplanation,
      child: SizedBox(
        width: 200,
        child: Text(
          skill.skillName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
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
    );
  }
}
