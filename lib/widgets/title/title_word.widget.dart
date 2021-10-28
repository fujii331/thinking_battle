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
      child: SizedBox(
        height: 235,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.6,
              child: Container(
                height: 235,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/title_word_back_4.png'),
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
                        // color: Colors.orange.shade400,
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
    );
  }
}
