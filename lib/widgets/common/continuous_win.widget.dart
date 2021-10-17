import 'package:flutter/material.dart';

class ContinuousWin extends StatelessWidget {
  final int continuousWinCount;
  final double wordMinusSize;

  // ignore: use_key_in_widget_constructors
  const ContinuousWin(
    this.continuousWinCount,
    this.wordMinusSize,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          continuousWinCount.toString() + ' 連勝中！',
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: 14 - wordMinusSize,
            fontStyle: FontStyle.italic,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.blueGrey.shade900,
          ),
        ),
        Text(
          continuousWinCount.toString() + ' 連勝中！',
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: 14 - wordMinusSize,
            fontStyle: FontStyle.italic,
            color: Colors.yellow.shade300,
          ),
        )
      ],
    );
  }
}
