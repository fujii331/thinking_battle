import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class GachaMovie extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const GachaMovie({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 2400),
        );
        soundEffect.play(
          'sounds/gacha.mp3',
          isNotification: true,
          volume: seVolume,
        );
        await Future.delayed(
          const Duration(milliseconds: 1500),
        );
        Navigator.pop(context);
      });
      return null;
    }, const []);

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 405,
            child: Stack(
              children: [
                Lottie.asset(
                  'assets/lottie/ReneeNakagawa.json',
                  width: 250,
                  fit: BoxFit.fitWidth,
                ),
                Column(
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        SizedBox(),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: Text(
                            'ReneeNakagawa@LottieFiles',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const SizedBox(height: 10),
          // Row(
          //   children: const [
          //     SizedBox(),
          //     Spacer(),
          //     Text(
          //       'Renee Nakagawa@LottieFiles',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: Colors.white70, fontSize: 11),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
