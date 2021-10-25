import 'package:flutter/material.dart';

class StackWord extends StatelessWidget {
  final String word;
  final Color wordColor;
  final double wordMinusSize;

  const StackWord({
    Key? key,
    required this.word,
    required this.wordColor,
    required this.wordMinusSize,
  }) : super(key: key);

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
