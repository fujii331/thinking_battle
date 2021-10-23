import 'package:flutter/material.dart';

import 'package:thinking_battle/models/skill.model.dart';

class SkillTooltip extends StatelessWidget {
  final Skill skill;
  final bool profileFlg;
  final double wordMinusSize;

  const SkillTooltip({
    Key? key,
    required this.skill,
    required this.profileFlg,
    required this.wordMinusSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Tooltip(
        message: skill.skillExplanation,
        child: profileFlg
            ? Stack(
                children: <Widget>[
                  Text(
                    '・ ' + skill.skillName,
                    style: TextStyle(
                      fontSize: 13 - wordMinusSize,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3.2
                        ..color = Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    '・ ' + skill.skillName,
                    style: TextStyle(
                      fontSize: 13 - wordMinusSize,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            : Text(
                skill.skillName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18 - wordMinusSize,
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
        textStyle: TextStyle(
          fontSize: 16 - wordMinusSize,
          color: Colors.white,
        ),
        showDuration: const Duration(seconds: 100),
        // waitDuration: const Duration(milliseconds: 1),
      ),
    );
  }
}
