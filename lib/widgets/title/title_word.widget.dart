import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TitleWord extends HookWidget {
  final ValueNotifier<bool> displayFlg;

  const TitleWord({
    Key? key,
    required this.displayFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: displayFlg.value ? 1 : 0,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30.0),
            height: 265,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: 235,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/background/title_word_back.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '水平思考\nモンスターズ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1,
                            fontSize: 47,
                            fontFamily: 'RocknRollOne',
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: <Color>[
                                  Colors.yellow.shade400,
                                  Colors.orange.shade300,
                                  Colors.yellow.shade700,
                                ],
                              ).createShader(
                                const Rect.fromLTWH(
                                  0.0,
                                  0.0,
                                  250.0,
                                  70.0,
                                ),
                              ),
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(6.0, 6.0),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Stack(
                          children: <Widget>[
                            Text(
                              '怪物たちの知恵比べ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'KaiseiOpti',
                                fontSize: 23.5,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 10
                                  ..color = Colors.grey.shade900,
                              ),
                            ),
                            Text(
                              '怪物たちの知恵比べ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'KaiseiOpti',
                                fontSize: 23.0,
                                foreground: Paint()..color = Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 195, top: 30),
            child: Center(
              child: SizedBox(
                height: 70,
                width: 110,
                child: Center(
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.9,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/background/title_vs.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 31,
                          top: 16,
                        ),
                        child: Text(
                          '対戦!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: 'MochiyPopOne',
                            // fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade700,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
