import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TutorialMessageRedFrame extends HookWidget {
  final int tutorialNumber;

  const TutorialMessageRedFrame({
    Key? key,
    required this.tutorialNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width;

    return Center(
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
                          color: Colors.white.withOpacity(0),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Stack(
                      children: [
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
                        Container(
                          width: 161,
                          height: 175,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0),
                            border: Border.all(
                              width: 2,
                              color: tutorialNumber == 1
                                  ? Colors.red
                                  : Colors.blueGrey,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, top: 15, bottom: 8, right: 30),
                                child: Row(
                                  children: [
                                    Container(
                                      // width: 80,
                                      // height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: tutorialNumber == 2
                                              ? Colors.red
                                              : Colors.white.withOpacity(0),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white.withOpacity(0),
                                        size: 18,
                                      ),
                                    ),
                                    const Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 8, right: 30),
                                child: Row(
                                  children: const [
                                    SizedBox(
                                      width: 27,
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 8, right: 30),
                                child: Row(
                                  children: const [
                                    SizedBox(
                                      width: 27,
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 8, right: 30),
                                child: Row(
                                  children: const [
                                    SizedBox(
                                      width: 27,
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                height: MediaQuery.of(context).size.height - 400,
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
            ],
          ),
        ),
      ),
    );
  }
}
