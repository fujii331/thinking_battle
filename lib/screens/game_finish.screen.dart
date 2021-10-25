import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/widgets/game_finish/actioned_list.widget.dart';
import 'package:thinking_battle/widgets/game_finish/result.widget.dart';

class GameFinishScreen extends HookWidget {
  const GameFinishScreen({Key? key}) : super(key: key);
  static const routeName = '/game-finish';

  // final bool? winFlg;
  // const GameFinishScreen({Key? key, required this.winFlg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool? winFlg = ModalRoute.of(context)?.settings.arguments as bool?;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
    final bool trainingFlg = useProvider(trainingProvider).state;
    final bool changedTraining = useProvider(changedTrainingProvider).state;
    final String friendMatchWord = useProvider(friendMatchWordProvider).state;
    final bool friendMatchFlg = friendMatchWord != '';

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);

    final resultBundge = winFlg == null
        ? Icons.sentiment_satisfied
        : winFlg
            ? Icons.sentiment_satisfied_alt
            : Icons.sentiment_dissatisfied_rounded;
    final Color resultColor = winFlg == null
        ? Colors.yellow.shade200
        : winFlg
            ? Colors.blue.shade200
            : Colors.red.shade200;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        context.read(bgmProvider).state.stop();
        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!trainingFlg || changedTraining) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (!friendMatchFlg) {
            // 対戦数
            context.read(matchedCountProvider).state += 1;
            prefs.setInt(
                'matchCount', context.read(matchedCountProvider).state);
          }

          if (winFlg == true) {
            if (!trainingFlg && !changedTraining) {
              // 対戦部屋
              DocumentReference<Map<String, dynamic>>? playingRoomDoc =
                  FirebaseFirestore.instance
                      .collection('playing-room')
                      .doc(context.read(matchingRoomIdProvider).state);

              playingRoomDoc.delete().catchError((error) {
                // データ削除に失敗した場合、何もしない
              });
            }

            if (!friendMatchFlg) {
              // 勝利数
              context.read(winCountProvider).state += 1;
              prefs.setInt('winCount', context.read(winCountProvider).state);

              final int updatedCount =
                  context.read(continuousWinCountProvider).state + 1;

              context.read(continuousWinCountProvider).state = updatedCount;
              prefs.setInt('continuousWinCount', updatedCount);

              if (updatedCount >
                  context.read(maxContinuousWinCountProvider).state) {
                context.read(maxContinuousWinCountProvider).state =
                    updatedCount;
                prefs.setInt('maxContinuousWinCount', updatedCount);
              }
            }
          } else if (!friendMatchFlg) {
            context.read(continuousWinCountProvider).state = 0;
            prefs.setInt('continuousWinCount', 0);
          }
        }

        context.read(bgmProvider).state = await soundEffect.loop(
          'sounds/title.mp3',
          volume: bgmVolume,
          isNotification: true,
        );
      });
      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          items: <TabItem>[
            TabItem(
              icon: Icon(
                resultBundge,
                color: resultColor.withOpacity(0.7),
              ),
              activeIcon: Icon(
                resultBundge,
                size: 32,
                color: resultColor,
              ),
              title: '結果',
            ),
            TabItem(
              icon: Icon(
                Icons.list_alt,
                color: Colors.white.withOpacity(0.7),
              ),
              activeIcon: const Icon(
                Icons.list_alt,
                size: 32,
                color: Colors.white,
              ),
              title: '振り返り',
            ),
          ],
          onTap: (int selectIndex) {
            screenNo.value = selectIndex;
            pageController.animateToPage(selectIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut);
          },
          initialActiveIndex: 0,
          style: TabStyle.react,
          backgroundColor: Colors.indigo.shade700,
          // currentIndex: screenNo.value,
        ),
        body: PageView(
          controller: pageController,
          // ページ切り替え時に実行する処理
          onPageChanged: (index) {
            screenNo.value = index;
          },
          children: [
            Result(
              winFlg: winFlg,
            ),
            const ActionedList(),
          ],
        ),
      ),
    );
  }
}
