import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/player.provider.dart';

class EditImage extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  // ignore: use_key_in_widget_constructors
  const EditImage(
    this.soundEffect,
    this.seVolume,
  );

  @override
  Widget build(BuildContext context) {
    final List<String> imageNumberList =
        useProvider(imageNumberListProvider).state;

    final List<Widget> imageRowList = [];
    List<Widget> imageList = [];

    for (String imageNumberString in imageNumberList) {
      // 画像をimageListに追加
      imageList.add(
        _imageSelect(
          context,
          int.parse(imageNumberString),
        ),
      );

      // 3個たまったらRowに追加
      if (imageList.length == 3) {
        imageRowList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imageList[0],
              imageList[1],
              imageList[2],
            ],
          ),
        );

        imageList = [];
      }
    }

    if (imageList.isNotEmpty) {
      imageRowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageList[0],
            imageList.length > 1
                ? imageList[1]
                : const SizedBox(height: 60, width: 60),
            const SizedBox(height: 60, width: 60),
          ],
        ),
      );
    }

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
          SizedBox(
            height: imageRowList.length > 2 ? 230 : 150,
            width: 230,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: imageRowList[index],
                );
              },
              itemCount: imageRowList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSelect(
    BuildContext context,
    int imageNumber,
  ) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        soundEffect.play(
          'sounds/change.mp3',
          isNotification: true,
          volume: seVolume,
        );
        context.read(imageNumberProvider).state = imageNumber;
        prefs.setInt('imageNumber', imageNumber);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
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
        child: Image.asset(
          'assets/images/characters/' + imageNumber.toString() + '.png',
        ),
      ),
    );
  }
}
