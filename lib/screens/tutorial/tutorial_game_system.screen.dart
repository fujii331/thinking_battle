import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';

class TutorialGameSystemScreen extends HookWidget {
  const TutorialGameSystemScreen({Key? key}) : super(key: key);
  static const routeName = '/tutorial-game-system';

  void startTutorial(
    BuildContext context,
    AudioCache soundEffect,
    double seVolume,
  ) {
    soundEffect.play(
      'sounds/tap.mp3',
      isNotification: true,
      volume: seVolume,
    );

    context.read(initialTutorialFlgProvider).state = true;
    context.read(trainingProvider).state = true;
    context.read(bgmProvider).state.stop();

    Navigator.of(context).pushReplacementNamed(
      GameStartScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool initialTutorialFlg =
        ModalRoute.of(context)?.settings.arguments as bool;
    const double betweenHeight = 22;
    final double? width = MediaQuery.of(context).size.width > 550 ? 500 : null;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return WillPopScope(
      onWillPop: () async => !initialTutorialFlg,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: Text(
            'ゲームシステム',
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'KaiseiOpti',
            ),
          ),
          automaticallyImplyLeading: !initialTutorialFlg,
          actions: <Widget>[
            initialTutorialFlg
                ? TextButton(
                    onPressed: () => startTutorial(
                      context,
                      soundEffect,
                      seVolume,
                    ),
                    child: const Text(
                      "対戦へ",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                : Container(),
          ],
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            background(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          initialTutorialFlg
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    bottom: 30,
                                  ),
                                  child: Text(
                                    'アプリのインストールありがとうございます！\n\nとりあえず下記のシステムを知っておけば十分なので、軽く読んでCPUと対戦してみましょう！',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.yellow.shade50,
                                    ),
                                  ),
                                )
                              : Container(),
                          _eachMessage(
                            1,
                            '対戦画面の上に表示されたお題の正解を先に解答したら勝ちです。（職業、食べ物など誰でも知ってるものがお題になる）',
                            width,
                          ),
                          const SizedBox(height: betweenHeight),
                          _eachMessage(
                            2,
                            'ゲームはターン制で、質問または解答を行うことで相手のターンに移ります。',
                            width,
                          ),
                          const SizedBox(height: betweenHeight),
                          _eachMessage(
                            3,
                            '質問は3つの選択肢から選ぶことができ、ターンが進むにつれ正解に近づくための重要な質問が出やすくなります。',
                            width,
                          ),
                          const SizedBox(height: betweenHeight),
                          _eachMessage(
                            4,
                            '質問の返答は「はい・いいえ・微妙」のいずれかで表示されます。\n※微妙：どちらとも言えない・はっきりわからない',
                            width,
                          ),
                          const SizedBox(height: betweenHeight),
                          _eachMessage(
                            5,
                            '質問をするときにSP（スキルポイント）を使ってスキルを発動することでゲームを有利に進めることができます。',
                            width,
                          ),
                          const SizedBox(height: betweenHeight),
                          _eachMessage(
                            6,
                            '質問を行うとSPが溜まっていきますが、解答を行ったときはSPは溜まりません。',
                            width,
                          ),
                          const SizedBox(height: betweenHeight),
                          _eachMessage(
                            7,
                            '解答を行って間違えると次のターンは解答ができなくなります。',
                            width,
                          ),
                          initialTutorialFlg
                              ? Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: ElevatedButton(
                                        child: const Text('CPUと対戦'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green.shade600,
                                          padding: const EdgeInsets.only(
                                            bottom: 3,
                                          ),
                                          shape: const StadiumBorder(),
                                          side: BorderSide(
                                            width: 2,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                        onPressed: () => startTutorial(
                                          context,
                                          soundEffect,
                                          seVolume,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _eachMessage(
    int number,
    String text,
    double? width,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade800,
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            StackLabel(
              word: 'その' + number.toString(),
              wordMinusSize: -7,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
