import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/data/messages.dart';

class TutorialMessage extends HookWidget {
  final int selectMessageId;
  final List<int> myMessageIdsList;

  const TutorialMessage({
    Key? key,
    required this.selectMessageId,
    required this.myMessageIdsList,
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 2,
                              color: Colors.blueGrey,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 15, bottom: 8, right: 30),
                                child: Row(
                                  children: [
                                    selectMessageId ==
                                            messageSettings[
                                                    myMessageIdsList[0] - 1]
                                                .id
                                        ? const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.check,
                                              size: 18,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 27,
                                          ),
                                    Text(
                                      messageSettings[myMessageIdsList[0] - 1]
                                          .message,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'NotoSansJP',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 8, right: 30),
                                child: Row(
                                  children: [
                                    selectMessageId ==
                                            messageSettings[
                                                    myMessageIdsList[1] - 1]
                                                .id
                                        ? const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.check,
                                              size: 18,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 27,
                                          ),
                                    Text(
                                      messageSettings[myMessageIdsList[1] - 1]
                                          .message,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'NotoSansJP',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 8, right: 30),
                                child: Row(
                                  children: [
                                    selectMessageId ==
                                            messageSettings[
                                                    myMessageIdsList[2] - 1]
                                                .id
                                        ? const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.check,
                                              size: 18,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 27,
                                          ),
                                    Text(
                                      messageSettings[myMessageIdsList[2] - 1]
                                          .message,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'NotoSansJP',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 15, right: 30),
                                child: Row(
                                  children: [
                                    selectMessageId ==
                                            messageSettings[
                                                    myMessageIdsList[3] - 1]
                                                .id
                                        ? const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.check,
                                              size: 18,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 27,
                                          ),
                                    Text(
                                      messageSettings[myMessageIdsList[3] - 1]
                                          .message,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'NotoSansJP',
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
