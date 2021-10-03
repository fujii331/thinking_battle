import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/common.provider.dart';

class CommentModal extends HookWidget {
  final String topText;
  final String secondText;

  // ignore: use_key_in_widget_constructors
  const CommentModal(
    this.topText,
    this.secondText,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 23,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            topText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            secondText,
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'Stick',
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 90,
            height: 40,
            child: ElevatedButton(
              onPressed: () => {
                soundEffect.play(
                  'sounds/cancel.mp3',
                  isNotification: true,
                  volume: seVolume,
                ),
                Navigator.pop(context),
              },
              child: const Text('閉じる'),
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
        ],
      ),
    );
  }
}
