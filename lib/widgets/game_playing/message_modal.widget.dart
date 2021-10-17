import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/models/message.model.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

class MessageModal extends HookWidget {
  const MessageModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = context.read(soundEffectProvider).state;
    final double seVolume = context.read(seVolumeProvider).state;
    final int selectMessageId = context.read(selectMessageIdProvider).state;

    final List<int> myMessageIdsList =
        context.read(myMessageIdsListProvider).state;

    final selectMessageState = useState(selectMessageId);

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
              'メッセージをセット',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '※メッセージは送ってから5ターン後に再度送ることができます',
            style: TextStyle(
              height: 1.3,
              fontSize: 17.0,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              _messageRow(
                context,
                selectMessageState,
                messageSettings[myMessageIdsList[0] - 1],
              ),
              _messageRow(
                context,
                selectMessageState,
                messageSettings[myMessageIdsList[1] - 1],
              ),
              _messageRow(
                context,
                selectMessageState,
                messageSettings[myMessageIdsList[2] - 1],
              ),
              _messageRow(
                context,
                selectMessageState,
                messageSettings[myMessageIdsList[3] - 1],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 80,
            height: 40,
            child: ElevatedButton(
              child: const Text('セット'),
              style: ElevatedButton.styleFrom(
                primary: selectMessageId != 0 || selectMessageState.value != 0
                    ? Colors.green.shade600
                    : Colors.green.shade200,
                textStyle: Theme.of(context).textTheme.button,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.green.shade700,
                ),
              ),
              onPressed: selectMessageId != 0 || selectMessageState.value != 0
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      // メッセージ
                      context.read(selectMessageIdProvider).state =
                          selectMessageState.value;

                      Navigator.pop(context);
                    }
                  : () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageRow(
    BuildContext context,
    ValueNotifier<int> selectMessageId,
    Message message,
  ) {
    int messageId = message.id;

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: selectMessageId.value == messageId,
            onChanged: (bool? checked) {
              if (checked!) {
                selectMessageId.value = messageId;
              } else {
                selectMessageId.value = 0;
              }
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .86 > 650
                ? 360
                : MediaQuery.of(context).size.width * .48,
            child: Text(
              message.message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
