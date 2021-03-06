import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

import 'package:thinking_battle/services/title//first_setting.service.dart';
import 'package:thinking_battle/services/title/should_update.service.dart';
import 'package:thinking_battle/widgets/title/another_app_link.widget.dart';

import 'package:thinking_battle/widgets/title/title_back.widget.dart';
import 'package:thinking_battle/widgets/title/title_button.widget.dart';
import 'package:thinking_battle/widgets/title/title_word.widget.dart';

class TitleScreen extends HookWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayFlg = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await shouldUpdate(context);

        await Future.delayed(
          const Duration(milliseconds: 1000),
        );
        displayFlg.value = true;
      });
      return null;
    }, const []);

    firstSetting(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          // 動画をpreloadするため
          Lottie.asset(
            'assets/lottie/ReneeNakagawa.json',
            width: 2,
            fit: BoxFit.fitWidth,
          ),
          const TitleBack(),
          Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                TitleWord(
                  displayFlg: displayFlg,
                ),
                const Spacer(),
                TitleButton(
                  displayFlg: displayFlg,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height > 600 ? 90 : 5),
                SizedBox(
                  height: 100,
                  child: AnotherAppLink(
                    context: context,
                    displayFlg: displayFlg,
                  ),
                ),
                SizedBox(height: Platform.isAndroid ? 0 : 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
