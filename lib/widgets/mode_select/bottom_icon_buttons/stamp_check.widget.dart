import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/widgets/common/modal_close_button.widget.dart';

class StampCheck extends HookWidget {
  final AudioCache soundEffect;

  const StampCheck({
    Key? key,
    required this.soundEffect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> explainTextState = useState('スタンプをタップして条件を確認');

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
              '成果スタンプ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          const ModalCloseButton(),
        ],
      ),
    );
  }

  Widget _rowStamp(
    bool checkedFlg,
    String explainText,
    ValueNotifier<String> explainTextState,
  ) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        image: checkedFlg
            ? const DecorationImage(
                image: AssetImage('assets/images/check.png'),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => explainTextState.value = explainText,
        ),
      ),
    );
  }

  Widget _stamp(
    bool checkedFlg,
    String explainText,
    ValueNotifier<String> explainTextState,
  ) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        image: checkedFlg
            ? const DecorationImage(
                image: AssetImage('assets/images/check.png'),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => explainTextState.value = explainText,
        ),
      ),
    );
  }
}
