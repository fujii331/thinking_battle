import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FaildMatching extends HookWidget {
  const FaildMatching({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 20,
        right: 10,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text(
            '通信失敗！',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '電波状況をご確認ください。\nメニュー画面に戻ります。',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Stick',
            ),
          ),
        ],
      ),
    );
  }
}
