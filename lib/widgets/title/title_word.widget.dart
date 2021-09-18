import 'package:flutter/material.dart';

class TitleWord extends StatelessWidget {
  const TitleWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      width: 265,
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade900,
          width: 1,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.zero,
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.zero,
        ),
        gradient: LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          colors: [
            const Color(0xff494132).withOpacity(0.6),
            const Color(0xff9941d8).withOpacity(0.6),
          ],
          stops: const [
            0.0,
            1.0,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            '水平思考対戦',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              fontSize: 42,
              fontFamily: 'KaiseiOpti',
              fontWeight: FontWeight.w800,
              color: Colors.orange.shade200,
            ),
          ),
          Text(
            'どっちが先に思いつく？',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade50,
              fontSize: 20,
              fontFamily: 'Stick',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
