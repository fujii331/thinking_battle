import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_finish/center_row_finish.widget.dart';
import 'package:thinking_battle/widgets/game_finish/user_profile_finish.widget.dart';
import 'package:thinking_battle/widgets/common/stamina.widget.dart';

class Result extends HookWidget {
  final bool? winFlg;

  // ignore: use_key_in_widget_constructors
  const Result(
    this.winFlg,
  );

  @override
  Widget build(BuildContext context) {
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final MaterialColor color = useProvider(colorProvider).state;
    final bool trainingFlg = context.read(trainingProvider).state;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.grey.shade900.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Stamina(),
                  const SizedBox(height: 30),
                  UserProfileFinish(
                    rivalInfo.color,
                    rivalInfo.imageNumber,
                    rivalInfo.name,
                    rivalInfo.rate,
                    false,
                    winFlg == null ? null : !winFlg!,
                    trainingFlg,
                  ),
                  const SizedBox(height: 30),
                  CenterRowFinish(winFlg),
                  UserProfileFinish(
                    color,
                    imageNumber,
                    playerName,
                    rate,
                    true,
                    winFlg,
                    trainingFlg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
