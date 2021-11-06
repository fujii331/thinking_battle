import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/widgets/game_play_content/question_modal_content.widget.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_comment_box.widget.dart';

class TutorialBottomModalComment extends StatelessWidget {
  final String comment;
  final double height;

  const TutorialBottomModalComment({
    Key? key,
    required this.comment,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(),
            const Spacer(),
            TutoriaCommentBox(
              comment: comment,
            ),
            Container(
              height: height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                // border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
