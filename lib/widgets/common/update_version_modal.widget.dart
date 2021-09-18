import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersionModal extends StatelessWidget {
  const UpdateVersionModal({Key? key}) : super(key: key);

  void _launchURL(
    String url,
  ) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '申し訳ありません。ストア情報が取得できませんでした。直接ストアより更新をお願いします。';
    }
  }

  @override
  Widget build(BuildContext context) {
    const appStoreUrl = 'https://apps.apple.com/app/id1572443299';
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=io.github.naoto613.lateral_thinking';

    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                "バージョン更新のお知らせ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 10,
              ),
              child: Text(
                "新しいバージョンのアプリが利用可能です。\nストアより更新版を入手してご利用下さい。",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(),
                const Spacer(),
                TextButton(
                  child: const Text("今すぐ更新"),
                  style: TextButton.styleFrom(
                    primary: Colors.orange.shade800,
                  ),
                  onPressed: () => {
                    _launchURL(
                      Platform.isIOS ? appStoreUrl : playStoreUrl,
                    ),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
