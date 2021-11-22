import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thinking_battle/widgets/common/stack_word.widget.dart';

class TopRowStart extends StatelessWidget {
  final bool matchingFlg;

  const TopRowStart({
    Key? key,
    required this.matchingFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Center(
        child: matchingFlg
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: StackWord(
                  word: '準備完了！',
                  wordColor: Colors.orange.shade200,
                  wordMinusSize: -13,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPouringHourGlassRefined(
                    color: Colors.orange.shade200,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  StackWord(
                    word: '待機中...',
                    wordColor: Colors.yellow.shade100,
                    wordMinusSize: -13,
                  ),
                ],
              ),
      ),
    );
  }
}
