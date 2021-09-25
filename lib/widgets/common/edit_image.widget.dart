import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

class EditImage extends HookWidget {
  const EditImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

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
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              'アイコンにしたい画像をタップ！',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _imageSelectRow(
            context,
            1,
            soundEffect,
            seVolume,
          ),
          _imageSelectRow(
            context,
            2,
            soundEffect,
            seVolume,
          ),
          _imageSelectRow(
            context,
            3,
            soundEffect,
            seVolume,
          ),
        ],
      ),
    );
  }

  Widget _imageSelectRow(
    BuildContext context,
    int rowNumber,
    AudioCache soundEffect,
    double seVolume,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _imageSelect(
            context,
            3 * (rowNumber - 1) + 1,
            soundEffect,
            seVolume,
          ),
          _imageSelect(
            context,
            3 * (rowNumber - 1) + 2,
            soundEffect,
            seVolume,
          ),
          _imageSelect(
            context,
            3 * (rowNumber - 1) + 3,
            soundEffect,
            seVolume,
          ),
        ],
      ),
    );
  }

  Widget _imageSelect(
    BuildContext context,
    int imageNumber,
    AudioCache soundEffect,
    double seVolume,
  ) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );
        context.read(imageNumberProvider).state = imageNumber;
        prefs.setInt('imageNumber', imageNumber);
        Navigator.pop(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Image.asset(
            'assets/images/' + imageNumber.toString() + '.png',
            height: 50,
          ),
        ),
      ),
    );
  }
}
