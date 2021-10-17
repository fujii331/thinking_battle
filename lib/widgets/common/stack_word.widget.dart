import 'package:flutter/material.dart';

class StackWord extends StatelessWidget {
  final String word;
  final Color wordColor;
  final double wordMinusSize;

  // ignore: use_key_in_widget_constructors
  const StackWord(
    this.word,
    this.wordColor,
    this.wordMinusSize,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          word,
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: 15.0 - wordMinusSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.grey.shade900,
          ),
        ),
        Text(
          word,
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: 15.0 - wordMinusSize,
            color: wordColor,
          ),
        )
      ],
    );
  }
}
