import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/widgets/title/profile_update_area.widget.dart';

class FirstSetting extends HookWidget {
  final ValueNotifier<bool> buttonPressedState;

  const FirstSetting({Key? key, required this.buttonPressedState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
        bottom: 25,
      ),
      width: MediaQuery.of(context).size.width > 500 ? 300 : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              '登録名とアイコンを設定！',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ProfileUpdateArea(buttonPressedState: buttonPressedState),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 18,
              left: 8,
            ),
            child: Text(
              '※ 後から変更できます',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'SawarabiGothic',
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
