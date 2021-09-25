import 'package:flutter/material.dart';

class TitleWord extends StatelessWidget {
  const TitleWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Column(
        children: [
          Text(
            '水平思考対戦',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              fontSize: 45,
              fontFamily: 'KaiseiOpti',
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade600,
              shadows: [
                Shadow(
                  color: Colors.grey.shade800,
                  offset: const Offset(0.0, 5.0),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Stack(
            children: <Widget>[
              Text(
                'どっちが先に思いつく？',
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
                'どっちが先に思いつく？',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'KaiseiOpti',
                  fontSize: 23.0,
                  foreground: Paint()
                    // ..style = PaintingStyle.stroke
                    // ..strokeWidth = 2
                    ..color = Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
