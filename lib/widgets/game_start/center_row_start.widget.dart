import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CenterRowStart extends HookWidget {
  final bool matchingFlg;
  final bool trainingFlg;
  final AudioCache soundEffect;
  final double seVolume;
  final ValueNotifier<bool> matchingQuitFlg;

  // ignore: use_key_in_widget_constructors
  const CenterRowStart(
    this.matchingFlg,
    this.trainingFlg,
    this.soundEffect,
    this.seVolume,
    this.matchingQuitFlg,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Center(
        child: matchingFlg
            ? Text(
                'VS',
                style: TextStyle(
                  color: Colors.red.shade200,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  shadows: <Shadow>[
                    Shadow(
                      color: Colors.grey.shade700,
                      offset: const Offset(3, 3),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              )
            : SizedBox(
                width: 90,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => {
                    matchingQuitFlg.value = true,
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    ),
                    Navigator.pop(context),
                  },
                  child: const Text('やめる'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade400,
                    padding: const EdgeInsets.only(
                      bottom: 3,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide(
                      width: 2,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
