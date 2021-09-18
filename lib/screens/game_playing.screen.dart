import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:thinking_battle/models/send_content.model.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/widgets/game_playing/info_toast/ready.widget.dart';
import 'package:thinking_battle/widgets/game_playing/info_toast/time_limit.widget.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons.widget.dart';
import 'package:thinking_battle/widgets/game_playing/content_list.widget.dart';
import 'package:thinking_battle/widgets/game_playing/top_row.widget.dart';

class GamePlayingScreen extends HookWidget {
  const GamePlayingScreen({Key? key}) : super(key: key);
  static const routeName = '/game-playing';

  void nextPerson(
    ValueNotifier<DateTime> subTime,
    DateTime baseSubTime,
    ValueNotifier<int> playerId,
    int numOfPlayersValue,
  ) {
    subTime.value = baseSubTime;
    if (playerId.value != numOfPlayersValue) {
      playerId.value++;
    } else {
      playerId.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final bool precedingFlg = args[0];
    final String quizThema = args[1];

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    final DateTime myTurnTime = useProvider(myTurnTimeProvider).state;

    final ValueNotifier<bool> displayFlgState = useState<bool>(false);

    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width;

    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (!displayFlgState.value) {
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Ready(
                precedingFlg,
                quizThema,
              );
            },
          );

          displayFlgState.value = true;
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          context.read(bgmProvider).state = await soundEffect.loop(
            'sounds/playing.mp3',
            volume: bgmVolume,
            isNotification: true,
          );
          initializeAction(
            context,
            precedingFlg,
            context.read(allQuestionsProvider).state,
            soundEffect,
            seVolume,
          );
        } else {
          // 時間切れ判定
          if (DateFormat('ss').format(myTurnTime) == '00') {
            context.read(myTurnFlgProvider).state = false;
            await showDialog<int>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const TimeLimit();
              },
            );

            final sendContent = SendContent(
              questionId: context.read(selectableQuestionsProvider).state[0].id,
              answer: '',
              skillIds: [],
            );

            // ターン行動実行
            turnAction(
              context,
              sendContent,
              true,
              scrollController,
              false,
              soundEffect,
              seVolume,
            );
          }
        }
      });
      return null;
    }, [myTurnTime]);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'テーマ：' + quizThema,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900]?.withOpacity(0.9),
        ),
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(0, 0, 0, 0.6),
              ),
              width: widthSetting,
              height: MediaQuery.of(context).size.height > 800 ? 800 : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: displayFlgState.value ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 30,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      const TopRow(),
                      const SizedBox(height: 30),
                      ContentList(scrollController),
                      const SizedBox(height: 30),
                      BottomActionButtons(scrollController),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
