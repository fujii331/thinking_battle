import 'package:flutter/material.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/widgets/game_playing/rival_info.widget.dart';

class TutorialRivalInfo extends StatelessWidget {
  final PlayerInfo rivalInfo;

  const TutorialRivalInfo({
    Key? key,
    required this.rivalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8 > 280.0
        ? 290.0
        : MediaQuery.of(context).size.width * 0.8 < 250
            ? MediaQuery.of(context).size.width * 0.92
            : MediaQuery.of(context).size.width * 0.82;

    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Column(
          children: [
            const SizedBox(),
            const Spacer(),
            Stack(
              children: [
                Column(
                  children: [
                    Center(
                      child: Container(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: width,
                          child: RivalInfo(rivalInfo: rivalInfo)),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    height: 35,
                    width: width,
                    child: Row(
                      children: const [
                        Spacer(),
                        Icon(Icons.close, size: 24, color: Colors.white),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(),
          ],
        ),
      ],
    );
  }
}
