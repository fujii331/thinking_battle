import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/info_contents.dart';
import 'package:thinking_battle/models/info.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/services/mode_select/check_stamp.service.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/widgets/common/stack_word.widget.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons.widget.dart';
import 'package:thinking_battle/widgets/mode_select/info_modal.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_info.widget.dart';
import 'package:thinking_battle/widgets/mode_select/play_game_buttons.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_room_button.widget.dart';

class ModeSelectScreen extends HookWidget {
  const ModeSelectScreen({Key? key}) : super(key: key);

  static const routeName = '/mode-select';

  void openInfoListModal(
    AudioCache soundEffect,
    double seVolume,
    BuildContext context,
    List<String> watchedInfoList,
  ) {
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
      width: MediaQuery.of(context).size.width * .86 > 450 ? 450 : null,
      body: InfoModal(
        soundEffect: soundEffect,
        seVolume: seVolume,
        watchedInfoList: watchedInfoList,
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final int cardNumber = useProvider(cardNumberProvider).state;
    final List colorList = returnCardColorList(cardNumber);
    final List<String> watchedInfoList =
        useProvider(watchedInfoListProvider).state;

    bool existNotWatchedInfoFlg = false;

    for (Info infoContent in infoContents) {
      if (!watchedInfoList.contains(infoContent.id.toString())) {
        existNotWatchedInfoFlg = true;
      }
    }

    final int matchedCount = useProvider(matchedCountProvider).state;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final bool heightOk = MediaQuery.of(context).size.height > 600;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // 日時
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String todayString =
            DateFormat('yyyy/MM/dd').format(DateTime.now());
        final String dataString = prefs.getString('dataString') ?? todayString;
        final int loginDays = prefs.getInt('loginDays') ?? 1;

        // 日時の更新が行われたらgpカウントとログイン日数を更新
        if (dataString != todayString) {
          context.read(gachaCountProvider).state = 5;
          prefs.setInt('gachaCount', 5);

          prefs.setInt('loginDays', loginDays + 1);
          context.read(loginDaysProvider).state = loginDays + 1;
          prefs.setString('dataString', todayString);

          checkStamp(
            context,
            prefs,
            1,
            soundEffect,
            seVolume,
          );
        } else {
          // ログイン日数
          context.read(loginDaysProvider).state = loginDays;
        }
        checkStamp(
          context,
          prefs,
          1,
          soundEffect,
          seVolume,
        );
      });
      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: Text(
            'メニュー',
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'KaiseiOpti',
            ),
          ),
          centerTitle: true,
          backgroundColor: colorList[0][1].withOpacity(0.3),
          leading: Center(
            child: Stack(
              children: [
                IconButton(
                  iconSize: 27,
                  icon: Icon(
                    Icons.info,
                    color: Colors.grey.shade200,
                  ),
                  onPressed: () => openInfoListModal(
                    soundEffect,
                    seVolume,
                    context,
                    watchedInfoList,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10),
                  child: InkWell(
                    onTap: () => openInfoListModal(
                      soundEffect,
                      seVolume,
                      context,
                      watchedInfoList,
                    ),
                    child: Icon(
                      Icons.circle,
                      color: existNotWatchedInfoFlg
                          ? Colors.red
                          : Colors.red.withOpacity(0),
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.home,
                color: Colors.grey.shade200,
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: SafeArea(
          child: SizedBox(
            width: 180,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: Drawer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: colorList[0][0],
                      stops: const [
                        0.2,
                        0.6,
                        0.9,
                      ],
                    ),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 25,
                        ),
                        height: 80,
                        color: colorList[0][1],
                        child: StackWord(
                          word: 'ホーム',
                          wordColor: Colors.grey.shade200,
                          wordMinusSize: -4,
                        ),
                      ),
                      MyRoomButton(
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                        colorList: colorList,
                        selectWord: 'マイデータ',
                      ),
                      MyRoomButton(
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                        colorList: colorList,
                        selectWord: 'スキル',
                      ),
                      MyRoomButton(
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                        colorList: colorList,
                        selectWord: 'アイコン',
                      ),
                      MyRoomButton(
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                        colorList: colorList,
                        selectWord: 'テーマ',
                      ),
                      MyRoomButton(
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                        colorList: colorList,
                        selectWord: 'メッセージ',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            background(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // const Stamina(),
                  const SizedBox(height: 95),
                  SizedBox(
                    height: MediaQuery.of(context).size.height > 600
                        ? 480
                        : MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MyInfo(
                            soundEffect: soundEffect,
                            seVolume: seVolume,
                            cardNumber: cardNumber,
                            colorList: colorList,
                            matchedCount: matchedCount,
                          ),
                          SizedBox(height: heightOk ? 50 : 30),
                          PlayGameButtons(
                            soundEffect: soundEffect,
                            seVolume: seVolume,
                            betweenHeight: heightOk ? 24 : 20,
                          ),
                          SizedBox(height: heightOk ? 50 : 30),
                          BottomIconButtons(
                            soundEffect: soundEffect,
                            seVolume: seVolume,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
