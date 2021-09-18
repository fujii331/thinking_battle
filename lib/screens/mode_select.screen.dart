import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_info.widget.dart';
import 'package:thinking_battle/widgets/mode_select/play_game_buttons.widget.dart';
import 'package:thinking_battle/widgets/common/stamina.widget.dart';

class ModeSelectScreen extends HookWidget {
  const ModeSelectScreen({Key? key}) : super(key: key);

  static const routeName = '/mode-select';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            background(),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.grey.shade900.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Stamina(),
                    MyInfo(),
                    SizedBox(height: 40),
                    PlayGameButtons(),
                    Spacer(),
                    BottomIconButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
