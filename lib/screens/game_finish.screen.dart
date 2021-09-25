import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/widgets/game_finish/actioned_list.widget.dart';
import 'package:thinking_battle/widgets/game_finish/result.widget.dart';

class GameFinishScreen extends HookWidget {
  const GameFinishScreen({Key? key}) : super(key: key);
  static const routeName = '/game-finish';

  @override
  Widget build(BuildContext context) {
    final bool? winFlg = ModalRoute.of(context)?.settings.arguments as bool?;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
    final bool trainingFlg = useProvider(trainingProvider).state;

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        context.read(bgmProvider).state.stop();
        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!trainingFlg && winFlg == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // 勝利数
          context.read(winCountProvider).state += 1;
          prefs.setInt('winCount', context.read(winCountProvider).state);
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
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.white.withOpacity(0.4),
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: winFlg == null
                  ? const Icon(Icons.sentiment_satisfied)
                  : winFlg
                      ? const Icon(Icons.sentiment_satisfied_alt)
                      : const Icon(Icons.sentiment_dissatisfied_rounded),
              label: '結果',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: '振り返り',
            ),
          ],
          onTap: (int selectIndex) {
            screenNo.value = selectIndex;
            pageController.animateToPage(selectIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut);
          },
          currentIndex: screenNo.value,
        ),
        body: PageView(
          controller: pageController,
          // ページ切り替え時に実行する処理
          onPageChanged: (index) {
            screenNo.value = index;
          },
          children: [
            Result(
              winFlg,
            ),
            const ActionedList(),
          ],
        ),
      ),
    );
  }
}
