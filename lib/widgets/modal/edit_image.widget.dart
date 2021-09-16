import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';

class EditImage extends HookWidget {
  final ValueNotifier<int> imageNumberState;

  // ignore: use_key_in_widget_constructors
  const EditImage(
    this.imageNumberState,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
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
              'アイコンにしたい画像をタップ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _imageSelectRow(
            context,
            imageNumberState,
            1,
            soundEffect,
          ),
          _imageSelectRow(
            context,
            imageNumberState,
            2,
            soundEffect,
          ),
          _imageSelectRow(
            context,
            imageNumberState,
            3,
            soundEffect,
          ),
        ],
      ),
    );
  }

  Widget _imageSelectRow(
    BuildContext context,
    ValueNotifier<int> imageNumberState,
    int rowNumber,
    AudioCache soundEffect,
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
            imageNumberState,
            3 * (rowNumber - 1) + 1,
            soundEffect,
          ),
          _imageSelect(
            context,
            imageNumberState,
            3 * (rowNumber - 1) + 2,
            soundEffect,
          ),
          _imageSelect(
            context,
            imageNumberState,
            3 * (rowNumber - 1) + 3,
            soundEffect,
          ),
        ],
      ),
    );
  }

  Widget _imageSelect(
    BuildContext context,
    ValueNotifier<int> imageNumberState,
    int imageNumber,
    AudioCache soundEffect,
  ) {
    return InkWell(
      onTap: () {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: 0.5,
        );
        imageNumberState.value = imageNumber;
        Navigator.pop(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
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
