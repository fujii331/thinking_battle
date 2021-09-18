import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'dart:io';

class TitleBack extends StatelessWidget {
  const TitleBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/title_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Lottie.asset('assets/lottie/star.json'),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Lottie.asset('assets/lottie/panda-and-turtle.json'),
          ),
        ),
        Column(
          children: [
            const SizedBox(),
            const Spacer(),
            Row(
              children: [
                const SizedBox(),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    right: Platform.isAndroid ? 10 : 15,
                    bottom: Platform.isAndroid ? 10 : 20,
                  ),
                  child: const Text(
                    'Sant Rojas, XiaoxinChen@LottieFiles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
