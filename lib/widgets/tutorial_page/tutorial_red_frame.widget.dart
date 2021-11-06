import 'package:flutter/material.dart';

class TutorialRedFrame extends StatelessWidget {
  final int tutorialNumber;

  const TutorialRedFrame({
    Key? key,
    required this.tutorialNumber,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1.5),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: tutorialNumber == 6
                                  ? Colors.red
                                  : Colors.white.withOpacity(0),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 30,
                          child: PopupMenuButton<int>(
                            icon: Icon(
                              Icons.mail,
                              size: 20,
                              color: Colors.white.withOpacity(0),
                            ),
                            shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey.withOpacity(0),
                                  width: 2),
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5 > 130
                              ? 130
                              : MediaQuery.of(context).size.width * 0.5,
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '残り',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 22,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        '30',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    ' 秒',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'あいての番',
                                style: TextStyle(
                                  color: Colors.green.shade200.withOpacity(0),
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: [3, 8].contains(tutorialNumber)
                                  ? Colors.red
                                  : Colors.white.withOpacity(0),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 50,
                          height: 40,
                        ),
                        const SizedBox(width: 9),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // ContentList
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: [2, 3].contains(tutorialNumber)
                              ? Colors.red
                              : Colors.white.withOpacity(0),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: MediaQuery.of(context).size.height - 290,
                      width: MediaQuery.of(context).size.width * .9,
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 4,
                          bottom: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BottomRow
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
                              color: tutorialNumber == 4
                                  ? Colors.red
                                  : Colors.white.withOpacity(0),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: tutorialNumber == 1
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
          ),
        ),
        Center(
          child: SizedBox(
            width: widthSetting,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 19,
                bottom: 17,
              ),
              child: Column(
                children: [
                  // TopLow
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1.5),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: [5, 7].contains(tutorialNumber)
                                  ? Colors.red
                                  : Colors.white.withOpacity(0),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 30,
                          child: PopupMenuButton<int>(
                            icon: Icon(
                              Icons.mail,
                              size: 20,
                              color: Colors.white.withOpacity(0),
                            ),
                            shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey.withOpacity(0),
                                width: 2,
                              ),
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5 > 130
                              ? 130
                              : MediaQuery.of(context).size.width * 0.5,
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '残り',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 22,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        '30',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    ' 秒',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'あいての番',
                                style: TextStyle(
                                  color: Colors.green.withOpacity(0),
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white.withOpacity(0),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 50,
                          height: 40,
                        ),
                        const SizedBox(width: 9),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // ContentList
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Colors.white.withOpacity(0),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height - 290,
                    width: MediaQuery.of(context).size.width * .9,
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 8,
                        left: 8,
                        top: 4,
                        bottom: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BottomRow
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
                              color: Colors.white.withOpacity(0),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white.withOpacity(0),
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
          ),
        ),
      ],
    );
  }
}
