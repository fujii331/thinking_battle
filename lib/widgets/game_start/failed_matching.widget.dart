import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FaildMatching extends HookWidget {
  final String topText;
  final String secondText;

  // ignore: use_key_in_widget_constructors
  const FaildMatching(
    this.topText,
    this.secondText,
  );

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
        children: <Widget>[
          Text(
            topText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            secondText,
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'Stick',
            ),
          ),
        ],
      ),
    );
  }
}
