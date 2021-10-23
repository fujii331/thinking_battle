import 'package:flutter/material.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';

class ProfileName extends StatelessWidget {
  final String playerName;
  final bool darkColorFlg;
  final double wordMinusSize;

  const ProfileName({
    Key? key,
    required this.playerName,
    required this.darkColorFlg,
    required this.wordMinusSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 17,
          child: StackLabel(
            word: 'name',
            wordMinusSize: wordMinusSize,
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
                offset: const Offset(1.5, 1.5),
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
