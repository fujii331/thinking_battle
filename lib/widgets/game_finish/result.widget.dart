import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/services/admob/bannar_action.service.dart';

import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/widgets/game_finish/center_row_finish.widget.dart';
import 'package:thinking_battle/widgets/game_finish/user_profile_finish.widget.dart';
// import 'package:thinking_battle/widgets/common/stamina.widget.dart';

class Result extends HookWidget {
  final bool? winFlg;

  const Result({
    Key? key,
    required this.winFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final int cardNumber = useProvider(cardNumberProvider).state;
    final int matchedCount = useProvider(matchedCountProvider).state;
    final int continuousWinCount =
        useProvider(continuousWinCountProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final bool trainingFlg = useProvider(trainingProvider).state;
    final bool changedTraining = useProvider(changedTrainingProvider).state;
    final String friendMatchWord = useProvider(friendMatchWordProvider).state;
    final bool notRateChangeFlg =
        (trainingFlg && !changedTraining) || friendMatchWord != '';
    final List<int> mySkillIdsList = useProvider(mySkillIdsListProvider).state;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
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
                      imageNumber: rivalInfo.imageNumber,
                      cardNumber: rivalInfo.cardNumber,
                      matchedCount: rivalInfo.matchedCount,
                      continuousWinCount: rivalInfo.continuousWinCount,
                      playerName: rivalInfo.name,
                      userRate: rivalInfo.rate,
                      mySkillIdsList: rivalInfo.skillList,
                      myDataFlg: false,
                      winFlg: winFlg == null ? null : !winFlg!,
                      notRateChangeFlg: notRateChangeFlg,
                    ),
                    const SizedBox(height: 15),
                    CenterRowFinish(winFlg: winFlg),
                    const SizedBox(height: 18),
                    UserProfileFinish(
                      imageNumber: imageNumber,
                      cardNumber: cardNumber,
                      matchedCount: matchedCount,
                      continuousWinCount: continuousWinCount,
                      playerName: playerName,
                      userRate: rate,
                      mySkillIdsList: mySkillIdsList,
                      myDataFlg: true,
                      winFlg: winFlg,
                      notRateChangeFlg: notRateChangeFlg,
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
