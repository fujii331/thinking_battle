import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/services/mode_select/get_item.service.dart';

class GachaMovie extends StatefulWidget {
  final BuildContext preScreenContext;
  final SharedPreferences prefs;
  final int buttonNumber;
  final List<List<int>> getitemNumberList;
  final List<String> itemNumberList;
  final AudioCache soundEffect;
  final double seVolume;
  final int patternValue;

  const GachaMovie({
    Key? key,
    required this.preScreenContext,
    required this.prefs,
    required this.buttonNumber,
    required this.getitemNumberList,
    required this.itemNumberList,
    required this.soundEffect,
    required this.seVolume,
    required this.patternValue,
  }) : super(key: key);

  @override
  _GachaMovie createState() => _GachaMovie();
}

class _GachaMovie extends State<GachaMovie> with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool heightOk = MediaQuery.of(context).size.height > 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: heightOk ? 400 : 330,
          child: Stack(
            children: [
              Center(
                child: Lottie.asset(
                  'assets/lottie/ReneeNakagawa.json',
                  height: heightOk ? 400 : 330,
                  fit: BoxFit.fitHeight,
                  controller: _controller,
                  onLoaded: (composition) {
                    setState(() {
                      _controller.duration = composition.duration;
                    });
                  },
                ),
              ),
              Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'ReneeNakagawa@LottieFiles',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: heightOk ? 11 : 9),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: !buttonPressed ? 1 : 0,
                  child: Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: SizedBox(
                          width: 90,
                          height: 40,
                          child: ElevatedButton(
                            child: const Text('回す'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange.shade600,
                              padding: const EdgeInsets.only(
                                bottom: 3,
                              ),
                              shape: const StadiumBorder(),
                              side: BorderSide(
                                width: 2,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            onPressed: !buttonPressed
                                ? () async {
                                    setState(() {
                                      // データを更新
                                      buttonPressed = true;
                                    });
                                    widget.soundEffect.play(
                                      'sounds/gacha_start.mp3',
                                      isNotification: true,
                                      volume: widget.seVolume,
                                    );

                                    _controller.forward();
                                    await Future.delayed(
                                      const Duration(milliseconds: 2400),
                                    );
                                    widget.soundEffect.play(
                                      'sounds/gacha.mp3',
                                      isNotification: true,
                                      volume: widget.seVolume,
                                    );
                                    await Future.delayed(
                                      const Duration(milliseconds: 1070),
                                    );
                                    _controller.stop();
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );
                                    Navigator.pop(context);
                                    final int randomNum = Random().nextInt(100);

                                    int addNum = 0;

                                    for (List<int> getitemNumberList
                                        in widget.getitemNumberList) {
                                      // 確率を上乗せしていく
                                      addNum += getitemNumberList[1];
                                      if (randomNum < addNum) {
                                        await getItem(
                                          widget.preScreenContext,
                                          widget.prefs,
                                          widget.buttonNumber,
                                          getitemNumberList[0],
                                          widget.itemNumberList,
                                          widget.soundEffect,
                                          widget.seVolume,
                                          widget.patternValue,
                                        );
                                        break;
                                      }
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
