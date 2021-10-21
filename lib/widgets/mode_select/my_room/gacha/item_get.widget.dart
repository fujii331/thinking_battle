import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/widgets/common/modal_close_button.widget.dart';

class ItemGet extends HookWidget {
  final int itemNumber;
  final bool newFlg;
  final int buttonNumber;

  // ignore: use_key_in_widget_constructors
  const ItemGet(
    this.itemNumber,
    this.newFlg,
    this.buttonNumber,
  );

  @override
  Widget build(BuildContext context) {
    final bool iconGachaFlg = buttonNumber == 1;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
            ),
            child: Text(
              newFlg
                  ? iconGachaFlg
                      ? 'アイコン獲得！'
                      : buttonNumber == 2
                          ? 'テーマ獲得！'
                          : 'メッセージ獲得！'
                  : '残念、持ってる...',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                const SizedBox(),
                const Spacer(),
                Text(
                  newFlg ? 'NEW!' : '+1 GP',
                  style: TextStyle(
                    fontSize: 20.0,
                    color:
                        newFlg ? Colors.yellow.shade800 : Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          buttonNumber == 3
              ? Text(
                  messageSettings[itemNumber - 1].message,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Container(
                  width: iconGachaFlg ? 120 : 126,
                  height: iconGachaFlg ? 120 : 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/images/' +
                          (iconGachaFlg ? 'characters/' : 'cards/') +
                          itemNumber.toString() +
                          '.png'),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
          const SizedBox(height: 30),
          const ModalCloseButton(),
        ],
      ),
    );
  }
}
