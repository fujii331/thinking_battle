import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/item_buy.widget.dart';

class GpChange extends HookWidget {
  final int itemNumber;
  final int needGpPoint;
  final int gachaPoint;
  final List<String> itemNumberList;
  final AudioCache soundEffect;
  final double seVolume;
  final int buttonNumber;

  const GpChange({
    Key? key,
    required this.itemNumber,
    required this.needGpPoint,
    required this.gachaPoint,
    required this.itemNumberList,
    required this.soundEffect,
    st,
    required this.seVolume,
    required this.buttonNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enableGet = gachaPoint >= needGpPoint;
    final bool alreadyGotFlg = itemNumberList.contains(itemNumber.toString());

    return !alreadyGotFlg
        ? SizedBox(
            width: 40,
            height: 20,
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Text(
                  needGpPoint.toString() + ' GP',
                  style: TextStyle(
                    fontSize: 10,
                    color: enableGet ? Colors.white : Colors.black,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown.shade500,
                textStyle: Theme.of(context).textTheme.button,
                padding: EdgeInsets.only(
                  top: Platform.isAndroid ? 2 : 1,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.brown.shade700,
                ),
              ),
              onPressed: enableGet
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        headerAnimationLoop: false,
                        dismissOnTouchOutside: true,
                        dismissOnBackKeyPress: true,
                        showCloseIcon: true,
                        animType: AnimType.SCALE,
                        width: MediaQuery.of(context).size.width * .86 > 550
                            ? 550
                            : null,
                        body: ItemBuy(
                          itemNumber: itemNumber,
                          needGpPoint: needGpPoint,
                          cardNumberList: itemNumberList,
                          previousContext: context,
                          buttonNumber: buttonNumber,
                        ),
                      ).show();
                    }
                  : null,
            ),
          )
        : Text(
            '入手済み',
            style: TextStyle(
              fontSize: 10,
              color: Colors.orange.shade700,
            ),
          );
  }
}
