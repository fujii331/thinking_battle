import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/widgets/common/modal_close_button.widget.dart';

class CommentModal extends HookWidget {
  final String topText;
  final String secondText;

  // ignore: use_key_in_widget_constructors
  const CommentModal(
    this.topText,
    this.secondText,
  );

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 30),
          const ModalCloseButton(),
        ],
      ),
    );
  }
}
