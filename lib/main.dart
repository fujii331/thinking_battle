import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/screens/game_finish.screen.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './screens/title.screen.dart';
import './screens/mode_select.screen.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

useWidgetLifecycleObserver(BuildContext context) {
  return use(_WidgetObserver(
    context,
  ));
}

class _WidgetObserver extends Hook<void> {
  final BuildContext context;

  _WidgetObserver(
    this.context,
  );

  @override
  HookState<void, Hook<void>> createState() {
    return _WidgetObserverState(
      context,
    );
  }
}

class _WidgetObserverState extends HookState<void, _WidgetObserver>
    with WidgetsBindingObserver {
  @override
  final BuildContext context;

  _WidgetObserverState(
    this.context,
  );

  @override
  void build(BuildContext context) {}

  @override
  void initHook() {
    super.initHook();
    Future(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // 音量設定
      final double? bgmVolume = prefs.getDouble('bgmVolume');

      if (bgmVolume != null) {
        context.read(bgmVolumeProvider).state = bgmVolume;
      } else {
        prefs.setDouble('bgmVolume', 0.2);
      }

      context.read(bgmProvider).state =
          await context.read(soundEffectProvider).state.loop(
                'sounds/title.mp3',
                isNotification: true,
                volume: context.read(bgmVolumeProvider).state,
              );
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    if (context.read(matchingWaitingIdProvider).state != '') {
      // 待機中ユーザーの削除
      FirebaseFirestore.instance
          .collection(context.read(friendMatchWordProvider).state != ''
              ? 'friend-matching-room'
              : 'random-matching-room')
          .doc(context.read(matchingWaitingIdProvider).state)
          .delete()
          .catchError((error) async {
        // データ削除に失敗した場合
        // 何もしない
      });
    }

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read(bgmProvider).state.pause();
    } else if (state == AppLifecycleState.resumed) {
      context.read(bgmProvider).state.resume();
    }
    super.didChangeAppLifecycleState(state);
  }
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useWidgetLifecycleObserver(
      context,
    );

    context
        .read(bgmProvider)
        .state
        .setVolume(context.read(bgmVolumeProvider).state);

    return MaterialApp(
      title: '水平思考モンスターズ',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        canvasColor: Colors.grey.shade100,
        fontFamily: 'KiwiMaru',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
          },
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              button: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const TitleScreen(),
        ModeSelectScreen.routeName: (BuildContext context) =>
            const ModeSelectScreen(),
        GameStartScreen.routeName: (BuildContext context) =>
            const GameStartScreen(),
        GamePlayingScreen.routeName: (BuildContext context) =>
            const GamePlayingScreen(),
        GameFinishScreen.routeName: (BuildContext context) =>
            const GameFinishScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const TitleScreen(),
        );
      },
    );
  }
}
