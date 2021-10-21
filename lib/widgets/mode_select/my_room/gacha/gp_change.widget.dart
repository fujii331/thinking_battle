import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/widgets/mode_select/my_room/gacha/item_buy.widget.dart';

class GpChange extends HookWidget {
  final int itemNumber;
  final int needGpPoint;
  final int gpPoint;
  final List<String> itemNumberList;
  final AudioCache soundEffect;
  final double seVolume;
  final int buttonNumber;

  // ignore: use_key_in_widget_constructors
  const GpChange(
    this.itemNumber,
    this.needGpPoint,
    this.gpPoint,
    this.itemNumberList,
    this.soundEffect,
    this.seVolume,
    this.buttonNumber,
  );

  @override
  Widget build(BuildContext context) {
    final bool enableGet = gpPoint >= needGpPoint;
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
                primary:
                    enableGet ? Colors.brown.shade500 : Colors.brown.shade200,
                textStyle: Theme.of(context).textTheme.button,
                padding: const EdgeInsets.only(
                  bottom: 2,
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
                        width: MediaQuery.of(context).size.width * .86 > 650
                            ? 650
                            : null,
                        body: ItemBuy(
                          itemNumber,
                          needGpPoint,
                          itemNumberList,
                          context,
                          buttonNumber,
                        ),
                      ).show();
                    }
                  : () {},
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
