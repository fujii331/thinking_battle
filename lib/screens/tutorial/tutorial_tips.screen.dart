import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';

class TutorialTipsScreen extends StatelessWidget {
  const TutorialTipsScreen({Key? key}) : super(key: key);
  static const routeName = '/tutorial-tips';

  @override
  Widget build(BuildContext context) {
    const double betweenHeight = 22;
    final double? width = MediaQuery.of(context).size.width > 550 ? 500 : null;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: Text(
          'Tips',
          style: TextStyle(
            color: Colors.grey.shade200,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'KaiseiOpti',
          ),
        ),
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
              SizedBox(height: Platform.isAndroid ? 100 : 120),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        _eachMessage(
                          1,
                          '質問を行うとSPが溜まっていきますが、解答したときはSPは溜まりません。',
                          width,
                        ),
                        const SizedBox(height: betweenHeight),
                        _eachMessage(
                          2,
                          '解答を行って間違えると次のターンは解答できなくなります。',
                          width,
                        ),
                        const SizedBox(height: betweenHeight),
                        _eachMessage(
                          3,
                          'SPが溜まっていればスキルは同時に複数発動することができます。\n（「質問隠し」＋「ナイス質問」などが有効！）',
                          width,
                        ),
                        const SizedBox(height: betweenHeight),
                        _eachMessage(
                          4,
                          '対戦中のスキル使用画面やあいての情報画面でスキル名を長押しするとスキルの説明が表示されます。',
                          width,
                        ),
                        const SizedBox(height: betweenHeight),
                        _eachMessage(
                          5,
                          'スキルは3つ、メッセージは4つ装備することができます。',
                          width,
                        ),
                        const SizedBox(height: betweenHeight),
                        _eachMessage(
                          6,
                          'お題・先攻後行はランダムで決定します。',
                          width,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
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
          color: Colors.cyan.shade900,
          border: Border.all(
            color: Colors.cyan.shade700,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            StackLabel(
              word: 'Tip' + number.toString(),
              wordMinusSize: -7,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'NotoSansJP',
                color: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
