import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/common/profile_update_area.widget.dart';

class MyRoom extends HookWidget {
  final TextEditingController playerNameController;

  // ignore: use_key_in_widget_constructors
  const MyRoom(
    this.playerNameController,
  );

  @override
  Widget build(BuildContext context) {
    final double rate = useProvider(rateProvider).state;
    final double maxRate = useProvider(maxRateProvider).state;
    final int matchCount = useProvider(matchedCountProvider).state;
    final int winCount = useProvider(winCountProvider).state;

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
          ProfileUpdateArea(
            playerNameController,
            false,
          ),
          const SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        _itemLabel('レート'),
                        _itemLabel('最大レート'),
                        _itemLabel('対戦回数'),
                        _itemLabel('勝ち数'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: Column(
                      children: <Widget>[
                        _item(rate.toString()),
                        _item(maxRate.toString()),
                        _item(matchCount.toString()),
                        _item(winCount.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemLabel(
    String label,
  ) {
    return SizedBox(
      height: 35,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blueGrey.shade900,
          fontSize: 20,
          fontFamily: 'KaiseiOpti',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _item(
    String item,
  ) {
    return SizedBox(
      height: 35,
      child: Text(
        item,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'KaiseiOpti',
        ),
      ),
    );
  }
}
