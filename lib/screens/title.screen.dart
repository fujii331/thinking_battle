import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/services/title//first_setting.service.dart';
import 'package:thinking_battle/services/title//time_start.service.dart';

import 'package:thinking_battle/widgets/title/title_back.widget.dart';
import 'package:thinking_battle/widgets/title/title_button.widget.dart';
import 'package:thinking_battle/widgets/title/title_word.widget.dart';

class TitleScreen extends HookWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // await shouldUpdate(context);

        // timeStart(
        //   context,
        // );
      });
      return null;
    }, const []);

    firstSetting(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          const TitleBack(),
          Center(
            child: Column(
              children: const <Widget>[
                SizedBox(height: 80),
                TitleWord(),
                Spacer(),
                TitleButton(),
                SizedBox(height: 110),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
