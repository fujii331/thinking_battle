import 'package:flutter/material.dart';

class StackLabel extends StatelessWidget {
  final String word;
  final double wordMinusSize;

  // ignore: use_key_in_widget_constructors
  const StackLabel(
    this.word,
    this.wordMinusSize,
  );

  @override
  Widget build(BuildContext context) {
    final bool skillFlg = word == 'skills';
    final bool nameFlg = word == 'name';

    return Stack(
      children: <Widget>[
        Text(
          word,
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: nameFlg ? 13 - wordMinusSize : 11 - wordMinusSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.grey.shade900,
          ),
        ),
        Text(
          word,
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: nameFlg ? 13 - wordMinusSize : 11 - wordMinusSize,
            color: skillFlg
                ? Colors.pink.shade100
                : nameFlg
                    ? Colors.blueGrey.shade200
                    : Colors.yellow.shade200,
          ),
        )
      ],
    );
  }
}
