import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/data/tutorial_widget.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_page.screen.dart';

class MatchContentListModal extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const MatchContentListModal({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double betweenHeight = 12;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Text(
              '項目を選択',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Column(
            children: <Widget>[
              _moveButton(
                context,
                '質問',
                matchContentQuestionTutorial,
                soundEffect,
                seVolume,
              ),
              const SizedBox(height: betweenHeight),
              _moveButton(
                context,
                'スキル',
                matchContentSkillTutorial,
                soundEffect,
                seVolume,
              ),
              const SizedBox(height: betweenHeight),
              _moveButton(
                context,
                '解答',
                matchContentAnswerTutorial,
                soundEffect,
                seVolume,
              ),
              const SizedBox(height: betweenHeight),
              _moveButton(
                context,
                'メッセージ',
                matchContentMessageTutorial(context),
                soundEffect,
                seVolume,
              ),
              const SizedBox(height: betweenHeight),
              _moveButton(
                context,
                'あいての情報',
                matchContentRivalInfoTutorial(context),
                soundEffect,
                seVolume,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _moveButton(
    BuildContext context,
    String text,
    List<Widget> childrenWidget,
    AudioCache soundEffect,
    double seVolume,
  ) {
    return InkWell(
      onTap: () async {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );

        Navigator.of(context).pushNamed(
          TutorialPageScreen.routeName,
          arguments: [
            text,
            childrenWidget,
          ],
        );
      },
      child: Container(
        height: 45,
        width: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
            stops: const [
              0.2,
              0.7,
            ],
          ),
          border: Border.all(
            color: Colors.grey,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: Platform.isAndroid ? 1 : 0,
              top: Platform.isAndroid ? 0 : 1,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
