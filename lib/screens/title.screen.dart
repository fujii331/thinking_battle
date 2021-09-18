import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/services/title//first_setting.service.dart';
import 'package:thinking_battle/services/title//should_update.service.dart';
import 'package:thinking_battle/services/title//time_start.service.dart';

import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/widgets/title/title_back.widget.dart';
import 'package:thinking_battle/widgets/title/title_button.widget.dart';
import 'package:thinking_battle/widgets/title/title_word.widget.dart';

class TitleScreen extends HookWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String playerName = useProvider(playerNameProvider).state;

    final int lifePoint = useProvider(lifePointProvider).state;
    final DateTime recoveryTime = useProvider(recoveryTimeProvider).state;
    final DateTime myTurnTime = useProvider(myTurnTimeProvider).state;
    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;

    final bool timerCancelFlg = useProvider(timerCancelFlgProvider).state;

    final loadingState = useState(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // await shouldUpdate(context);

        timeStart(
          context,
          recoveryTime,
          lifePoint,
          timerCancelFlg,
          myTurnFlg,
          myTurnTime,
        );
      });
      return null;
    }, const []);

    firstSetting(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const TitleBack(),
          Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 80),
                const TitleWord(),
                const Spacer(),
                TitleButton(
                  loadingState,
                  playerName == '',
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
