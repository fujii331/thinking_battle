import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/widgets/game_play_content/skill_modal_content.widget.dart';

class SkillModal extends HookWidget {
  final ValueNotifier<bool> changeFlgState;
  final AudioCache soundEffect;
  final double seVolume;

  const SkillModal({
    Key? key,
    required this.changeFlgState,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> selectSkillIdsList =
        useProvider(selectSkillIdsProvider).state;

    // final bool isEventMatch = useProvider(isEventMatchProvider).state;
    final List<int> mySkillIdsList =
        // isEventMatch
        // ? useProvider(randomSkillIdsListProvider).state
        // :
        useProvider(mySkillIdsListProvider).state;

    final int currentSkillPoint = useProvider(currentSkillPointProvider).state;

    return SkillModalContent(
      changeFlgState: changeFlgState,
      soundEffect: soundEffect,
      seVolume: seVolume,
      selectSkillIdsList: selectSkillIdsList,
      mySkillIdsList: mySkillIdsList,
      currentSkillPoint: currentSkillPoint,
    );
  }
}
