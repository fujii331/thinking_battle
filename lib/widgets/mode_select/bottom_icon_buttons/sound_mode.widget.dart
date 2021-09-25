import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';

class SoundMode extends HookWidget {
  final AudioCache soundEffect;

  // ignore: use_key_in_widget_constructors
  const SoundMode(
    this.soundEffect,
  );

  @override
  Widget build(BuildContext context) {
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
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
          const Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 25,
            ),
            child: Text(
              'スライドして音量調節',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            width: double.infinity,
            child: const Text(
              'BGM音量',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTickMarkColor: Colors.blue.shade100,
              activeTickMarkColor: Colors.blue,
            ),
            child: Slider(
              value: bgmVolume * 100,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (double value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                context.read(bgmProvider).state.setVolume(value * 0.01);
                context.read(bgmVolumeProvider).state = value * 0.01;
                prefs.setDouble('bgmVolume', value * 0.01);
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            width: double.infinity,
            child: const Text(
              'SE音量',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTickMarkColor: Colors.blue.shade100,
              activeTickMarkColor: Colors.blue,
            ),
            child: Slider(
              value: seVolume * 100,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (double value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                context.read(seVolumeProvider).state = value * 0.01;
                prefs.setDouble('seVolume', value * 0.01);
              },
            ),
          ),
          const SizedBox(height: 25),
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
