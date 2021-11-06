import 'package:flutter/material.dart';

class TutorialQuestionModalRedFrame extends StatelessWidget {
  final int tutorialNumber;
  final List<int> selectSkillIds;

  const TutorialQuestionModalRedFrame({
    Key? key,
    required this.tutorialNumber,
    required this.selectSkillIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingWidth = MediaQuery.of(context).size.width > 550.0
        ? (MediaQuery.of(context).size.width - 550) / 2
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
                    Text(
                      '質問をタップして選択',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white.withOpacity(0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 19),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Container(
                            height: 28,
                            width: tutorialNumber == 5
                                ? 90
                                : tutorialNumber == 6
                                    ? 60
                                    : 75,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: [4, 5, 6].contains(tutorialNumber)
                                    ? Colors.red
                                    : Colors.white.withOpacity(0),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 1),
                    selectSkillIds.contains(2)
                        ? Column(
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  left: 8,
                                  right: 8,
                                ),
                                height: 135,
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: tutorialNumber == 5
                                            ? Colors.red
                                            : Colors.white.withOpacity(0),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 137,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: tutorialNumber == 1
                                            ? Colors.red
                                            : Colors.white.withOpacity(0),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                    ),
                                    height: 135,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: tutorialNumber == 2
                                                ? Colors.red
                                                : Colors.white.withOpacity(0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: tutorialNumber == 3
                                    ? Colors.red
                                    : Colors.white.withOpacity(0),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: [2, 4, 5, 6].contains(tutorialNumber)
                                    ? Colors.red
                                    : Colors.white.withOpacity(0),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
