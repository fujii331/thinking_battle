import 'package:flutter/material.dart';

class TutorialSkillModalRedFrame extends StatelessWidget {
  final int tutorialNumber;

  const TutorialSkillModalRedFrame({
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
                  Text(
                    '使うスキルを選んでセット',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white.withOpacity(0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0),
                                  border: Border.all(
                                    width: 3,
                                    color: [1, 2].contains(tutorialNumber)
                                        ? Colors.red
                                        : Colors.white.withOpacity(0),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const SizedBox(
                                  height: 42,
                                  width: 42,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: SizedBox(
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white.withOpacity(0),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const SizedBox(
                                  height: 42,
                                  width: 42,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: SizedBox(
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0),
                                  border: Border.all(
                                    width: 3,
                                    color: tutorialNumber == 1
                                        ? Colors.blue
                                        : Colors.white.withOpacity(0),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: SizedBox(
                                    height: 42,
                                    width: 42,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: SizedBox(
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: tutorialNumber == 2
                            ? Colors.red
                            : Colors.white.withOpacity(0),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
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
