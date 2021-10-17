import 'package:flutter/material.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';

class ProfileName extends StatelessWidget {
  final String playerName;
  final bool darkColorFlg;
  final double wordMinusSize;

  // ignore: use_key_in_widget_constructors
  const ProfileName(
    this.playerName,
    this.darkColorFlg,
    this.wordMinusSize,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 17,
          child: StackLabel(
            'name',
            wordMinusSize,
          ),
        ),
        Text(
          playerName,
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
            fontSize: 15 - wordMinusSize,
            fontWeight: FontWeight.bold,
            color: darkColorFlg ? Colors.white : Colors.black,
            shadows: <Shadow>[
              Shadow(
                offset: const Offset(2.0, 3.0),
                blurRadius: 2.0,
                color:
                    darkColorFlg ? Colors.grey.shade900 : Colors.grey.shade600,
              )
            ],
          ),
        ),
      ],
    );
  }
}
