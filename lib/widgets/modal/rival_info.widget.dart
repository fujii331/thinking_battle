import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/skill.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/skills.dart';

class RivalInfo extends HookWidget {
  const RivalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;
    final MaterialColor rivalColor = useProvider(rivalColorProvider).state;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: rivalColor,
                      width: 4,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.asset(
                      'assets/images/' +
                          rivalInfo.imageNumber.toString() +
                          '.png',
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                        child: Text(
                          'name',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        rivalInfo.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                        child: Text(
                          'rate',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        rivalInfo.rate.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          '相手のセットスキル',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ),
                      _skillItem(skillSettings[rivalInfo.skillList[0] - 1]),
                      _skillItem(skillSettings[rivalInfo.skillList[1] - 1]),
                      _skillItem(skillSettings[rivalInfo.skillList[2] - 1]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillItem(
    Skill skill,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Tooltip(
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
      ),
    );
  }
}
