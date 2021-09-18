import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/widgets/common/profile_update_area.widget.dart';

class FirstSetting extends HookWidget {
  const FirstSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerNameController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              '名前とアイコンを設定',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ProfileUpdateArea(
            playerNameController,
            true,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              '※後から変更できます',
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