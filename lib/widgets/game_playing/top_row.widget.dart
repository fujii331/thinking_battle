import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_play_content/top_row_content.widget.dart';

class TopRow extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final PlayerInfo rivalInfo;
  final bool myTurnFlg;
  final List colorList;
  final bool initialTutorialFlg;

  const TopRow({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.rivalInfo,
    required this.myTurnFlg,
    required this.colorList,
    required this.initialTutorialFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool displayMyturnSetFlg =
        useProvider(displayMyturnSetFlgProvider).state;
    final bool displayRivalturnSetFlg =
        useProvider(displayRivalturnSetFlgProvider).state;
    final int spChargeTurn = useProvider(spChargeTurnProvider).state;
    final int currentSkillPoint = useProvider(currentSkillPointProvider).state;
    final int myTurnTime = useProvider(myTurnTimeProvider).state;
    final int afterMessageTime = useProvider(afterMessageTimeProvider).state;
    final int selectMessageId = useProvider(selectMessageIdProvider).state;

    return TopRowContent(
      soundEffect: soundEffect,
      seVolume: seVolume,
      rivalInfo: rivalInfo,
      myTurnTime: myTurnTime,
      myTurnFlg: myTurnFlg,
      currentSkillPoint: currentSkillPoint,
      spChargeTurn: spChargeTurn,
      displayMyturnSetFlg: displayMyturnSetFlg,
      displayRivalturnSetFlg: displayRivalturnSetFlg,
      colorList: colorList,
      afterMessageTime: afterMessageTime,
      selectMessageId: selectMessageId,
      initialTutorialFlg: initialTutorialFlg,
    );
  }
}
