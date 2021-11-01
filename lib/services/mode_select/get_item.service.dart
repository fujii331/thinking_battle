import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/item_get.widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future getItem(
  BuildContext context,
  SharedPreferences prefs,
  int buttonNumber,
  int itemNumber,
  List<String> itemNumberList,
  AudioCache soundEffect,
  double seVolume,
  int patternValue,
) async {
  bool newItemFlg = false;

  if (patternValue == 1) {
    // チケット消費
    context.read(gachaTicketProvider).state -= 1;
    prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
  } else if (patternValue == 2) {
    context.read(gachaCountProvider).state -= 1;
    prefs.setInt('gachaCount', context.read(gachaCountProvider).state);
  }

  if (itemNumberList.contains(itemNumber.toString())) {
    soundEffect.play(
      'sounds/same_item.mp3',
      isNotification: true,
      volume: seVolume,
    );

    // すでに持っている場合
    // GPを更新
    context.read(gachaPointProvider).state += 1;
    prefs.setInt('gachaPoint', context.read(gachaPointProvider).state);
  } else {
    soundEffect.play(
      'sounds/new_item.mp3',
      isNotification: true,
      volume: seVolume,
    );

    // 新しいアイテムの場合
    newItemFlg = true;
    // 新しいテーマを追加
    itemNumberList.add(itemNumber.toString());

    itemNumberList.sort((a, b) => int.parse(a) - int.parse(b));

    if (buttonNumber == 1) {
      context.read(imageNumberListProvider).state = itemNumberList;
      prefs.setStringList('imageNumberList', itemNumberList);
    } else if (buttonNumber == 2) {
      context.read(cardNumberListProvider).state = itemNumberList;
      prefs.setStringList('cardNumberList', itemNumberList);
    }
    if (buttonNumber == 3) {
      context.read(messageIdsListProvider).state = itemNumberList;
      prefs.setStringList('messageIdsList', itemNumberList);
    }
  }

  AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    showCloseIcon: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 450 ? 450 : null,
    body: ItemGet(
      preWidgetContext: context,
      prefs: prefs,
      itemNumber: itemNumber,
      newFlg: newItemFlg,
      buttonNumber: buttonNumber,
      soundEffect: soundEffect,
      seVolume: seVolume,
    ),
  ).show();
}
