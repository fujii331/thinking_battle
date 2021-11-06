import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinking_battle/widgets/tutorial_page/tutorial_comment_box.widget.dart';

class TutoriaGamePlayingComment extends StatelessWidget {
  final String comment;

  const TutoriaGamePlayingComment({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: widthSetting,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
                bottom: 20,
              ),
              child: Column(
                children: [
                  // TopLow
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    height: 40,
                  ),
                  const SizedBox(height: 15),
                  // ContentList
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 4,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(),
                            const Spacer(),
                            TutoriaCommentBox(
                              comment: comment,
                            ),
                            const Spacer(),
                            const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BottomRow
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
