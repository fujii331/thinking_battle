import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/widgets/game_finish/center_row_finish.widget.dart';
import 'package:thinking_battle/widgets/game_finish/user_profile_finish.widget.dart';
// import 'package:thinking_battle/widgets/common/stamina.widget.dart';

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
    final int matchedCount = useProvider(matchedCountProvider).state;
    final int continuousWinCount =
        useProvider(continuousWinCountProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final double maxRate = useProvider(maxRateProvider).state;
    final bool trainingFlg = useProvider(trainingProvider).state;
    final bool changedTraining = useProvider(changedTrainingProvider).state;
    final String friendMatchWord = useProvider(friendMatchWordProvider).state;
    final bool notRateChangeFlg =
        (trainingFlg && !changedTraining) || friendMatchWord != '';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueGrey.shade900.withOpacity(0.7),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // const Stamina(),
                    const SizedBox(height: 20),
                    UserProfileFinish(
                      rivalInfo.imageNumber,
                      rivalInfo.matchedCount,
                      rivalInfo.continuousWinCount,
                      rivalInfo.name,
                      rivalInfo.rate,
                      rivalInfo.maxRate,
                      false,
                      winFlg == null ? null : !winFlg!,
                      notRateChangeFlg,
                    ),
                    const SizedBox(height: 15),
                    CenterRowFinish(winFlg),
                    const SizedBox(height: 15),
                    UserProfileFinish(
                      imageNumber,
                      matchedCount,
                      continuousWinCount,
                      playerName,
                      rate,
                      maxRate,
                      true,
                      winFlg,
                      notRateChangeFlg,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
