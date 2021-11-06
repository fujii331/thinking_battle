import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/models/message.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

class MessagePopUpMenu extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;
  final int afterMessageTime;
  final int selectMessageId;

  const MessagePopUpMenu({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
    required this.afterMessageTime,
    required this.selectMessageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enableMessageFlg = myTurnFlg && afterMessageTime == 0;
    final List<int> myMessageIdsList =
        context.read(myMessageIdsListProvider).state;

    return PopupMenuButton<int>(
      icon: Icon(
        selectMessageId == 0 ? Icons.mail : Icons.mark_email_read,
        size: 20,
        color: selectMessageId != 0
            ? Colors.yellow.shade200
            : enableMessageFlg
                ? Colors.white
                : Colors.grey.shade600,
      ),
      enabled: enableMessageFlg,
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      onSelected: (int result) {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );

        context.read(selectMessageIdProvider).state =
            result != selectMessageId ? result : 0;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        _messageMenu(
          selectMessageId,
          messageSettings[myMessageIdsList[0] - 1],
        ),
        _messageMenu(
          selectMessageId,
          messageSettings[myMessageIdsList[1] - 1],
        ),
        _messageMenu(
          selectMessageId,
          messageSettings[myMessageIdsList[2] - 1],
        ),
        _messageMenu(
          selectMessageId,
          messageSettings[myMessageIdsList[3] - 1],
        ),
      ],
    );
  }

  PopupMenuEntry<int> _messageMenu(
    int selectMessageId,
    Message message,
  ) {
    return PopupMenuItem<int>(
      value: message.id,
      child: Row(
        children: [
          selectMessageId == message.id
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
          Text(message.message),
        ],
      ),
    );
  }
}
