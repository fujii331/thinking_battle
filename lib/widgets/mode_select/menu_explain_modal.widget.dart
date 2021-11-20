import 'package:flutter/material.dart';

class MenuExplainModal extends StatelessWidget {
  const MenuExplainModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool widthOk = MediaQuery.of(context).size.width > 350;
    const double betweenHeight = 25;
    final double betweenWidth = widthOk ? 15 : 12;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 13,
        right: 10,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'メニュー画面説明',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _itemIcon(Icons.home),
                    SizedBox(width: betweenWidth),
                    _item(context, 'スキルなどの変更\n対戦成績の確認', widthOk),
                  ],
                ),
                const SizedBox(height: betweenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _itemIcon(Icons.info),
                    SizedBox(width: betweenWidth),
                    _item(context, 'お知らせの確認', widthOk),
                  ],
                ),
                const SizedBox(height: betweenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _itemPicture('music_icon'),
                    SizedBox(width: betweenWidth),
                    _item(context, '音量の設定', widthOk),
                  ],
                ),
                const SizedBox(height: betweenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _itemPicture('stamp_icon'),
                    SizedBox(width: betweenWidth),
                    _item(context, '成果スタンプの確認', widthOk),
                  ],
                ),
                const SizedBox(height: betweenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _itemPicture('gacha_icon'),
                    SizedBox(width: betweenWidth),
                    _item(context, 'アイコンなどのガチャ', widthOk),
                  ],
                ),
                const SizedBox(height: betweenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _itemPicture('book_icon'),
                    SizedBox(width: betweenWidth),
                    _item(context, 'ゲームシステムの確認', widthOk),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: betweenHeight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ランダムマッチ',
                  style: TextStyle(
                    fontSize: widthOk ? 15 : 14,
                    color: Colors.blueGrey.shade500,
                  ),
                ),
                Text(
                  '近いレートのランダムな誰かと対戦できます。',
                  style: TextStyle(
                    fontSize: widthOk ? 16 : 15,
                  ),
                ),
                const SizedBox(height: betweenHeight),
                Text(
                  'フレンドマッチ',
                  style: TextStyle(
                    fontSize: widthOk ? 15 : 14,
                    color: Colors.blueGrey.shade500,
                  ),
                ),
                Text(
                  'あいことばを使って知っている人と対戦できます。',
                  style: TextStyle(
                    fontSize: widthOk ? 16 : 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemIcon(
    IconData icon,
  ) {
    return SizedBox(
      height: 28,
      child: Icon(
        icon,
        size: 28,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _itemPicture(
    String imagePath,
  ) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bottom_icons/' + imagePath + '.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String item,
    bool widthOk,
  ) {
    return SizedBox(
      child: Text(
        item,
        style: TextStyle(
          color: Colors.black,
          fontSize: widthOk ? 16 : 14,
          fontFamily: 'KaiseiOpti',
        ),
      ),
    );
  }
}
