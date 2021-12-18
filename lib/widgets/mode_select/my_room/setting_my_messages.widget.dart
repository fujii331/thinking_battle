import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/models/message.model.dart';

import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/data/messages.dart';

class SettingMyMessages extends HookWidget {
  final List<int> selectingMessageList;
  final AudioCache soundEffect;
  final double seVolume;

  const SettingMyMessages({
    Key? key,
    required this.selectingMessageList,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final judgeFlgState = useState(true);

    final List<String> messageIdsList =
        useProvider(messageIdsListProvider).state;
    List<Widget> messageList = [];

    for (String messageIdString in messageIdsList) {
      // 画像をcardListに追加
      messageList.add(
        _messageRow(
          context,
          selectingMessageList,
          messageSettings[int.parse(messageIdString) - 1],
          selectingMessageList.length == 4,
          judgeFlgState,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 23,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 12,
            ),
            child: Text(
              '対戦中に送れる4つのメッセージを選択',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'NotoSansJP',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 210,
            width: MediaQuery.of(context).size.width * .86 > 450
                ? 350
                : MediaQuery.of(context).size.width * .60,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return messageList[index];
              },
              itemCount: messageList.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SizedBox(
              width: 90,
              height: 40,
              child: ElevatedButton(
                onPressed: selectingMessageList.length == 4
                    ? () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        selectingMessageList.sort();
                        soundEffect.play(
                          'sounds/change.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        context.read(myMessageIdsListProvider).state =
                            selectingMessageList;

                        prefs.setStringList(
                            'messageList',
                            selectingMessageList
                                .map((message) => message.toString())
                                .toList());
                        Navigator.pop(context);
                      }
                    : () {},
                child: const Text('更新'),
                style: ElevatedButton.styleFrom(
                  primary: selectingMessageList.length == 4
                      ? Colors.orange
                      : Colors.orange.shade200,
                  padding: EdgeInsets.only(
                    bottom: Platform.isAndroid ? 3 : 1,
                  ),
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    width: 2,
                    color: Colors.orange.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageRow(
    BuildContext context,
    List<int> selectingMessageList,
    Message message,
    bool isSetEnough,
    ValueNotifier<bool> judgeFlgState,
  ) {
    final int messageId = message.id;
    final bool isSet = selectingMessageList.contains(messageId);
    final bool cannotUse = isSetEnough && !isSet;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Checkbox(
              value: isSet,
              hoverColor: Colors.grey,
              onChanged: cannotUse
                  ? null
                  : (bool? checked) {
                      if (checked!) {
                        selectingMessageList.add(messageId);
                      } else {
                        selectingMessageList
                            .removeWhere((int number) => number == messageId);
                      }
                      judgeFlgState.value = !judgeFlgState.value;
                    },
            ),
            cannotUse
                ? Row(
                    children: [
                      const SizedBox(
                        width: 16.3,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 16.3,
                          ),
                          Container(
                            width: 15.5,
                            height: 15.5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              border: Border.all(
                                color: Colors.grey.shade700,
                                width: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container()
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .86 > 450
              ? 250
              : MediaQuery.of(context).size.width * .42,
          child: Text(
            message.message,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'NotoSansJP',
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
