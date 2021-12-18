import 'dart:io';

import 'package:flutter/material.dart';

class TutorialAnswerModalRedFrame extends StatelessWidget {
  final int tutorialNumber;

  const TutorialAnswerModalRedFrame({
    Key? key,
    required this.tutorialNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingWidth = MediaQuery.of(context).size.width > 450.0
        ? (MediaQuery.of(context).size.width - 450) / 2
        : 5;
    return Column(
      children: [
        const SizedBox(),
        const Spacer(),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.zero,
              bottomLeft: Radius.zero,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: paddingWidth,
                right: paddingWidth,
                bottom: 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        iconSize: 28,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0),
                        ),
                        onPressed: null,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 25,
                    ),
                    child: Text(
                      '候補から答えを選択',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '答えは',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0),
                          fontFamily: 'NotoSansJP',
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 10,
                        ),
                        child: Container(
                          width: 163,
                          height: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: [1, 2].contains(tutorialNumber)
                                  ? Colors.red
                                  : Colors.white.withOpacity(0),
                              width: 3,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(),
                        ),
                      ),
                      Text(
                        'だ！',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0),
                          fontFamily: 'NotoSansJP',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: [2, 4].contains(tutorialNumber)
                            ? Colors.red
                            : Colors.white.withOpacity(0),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Platform.isAndroid ? Container() : const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
