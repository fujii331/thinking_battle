import 'package:flutter/material.dart';

import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/widgets/game_start/user_profile_start.widget.dart';

class RivalInfo extends StatelessWidget {
  final PlayerInfo rivalInfo;

  // ignore: use_key_in_widget_constructors
  const RivalInfo(
    this.rivalInfo,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'あいての情報',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.grey.shade900,
            child: UserProfileStart(
              rivalInfo.imageNumber,
              rivalInfo.matchedCount,
              rivalInfo.continuousWinCount,
              rivalInfo.name,
              rivalInfo.rate,
              rivalInfo.maxRate,
              rivalInfo.skillList,
              false,
            ),
          ),
        ],
      ),
    );
  }
}
