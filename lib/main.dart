import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  // MobileAds.instance.initialize();

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
      context.read(bgmProvider).state =
          await context.read(soundEffectProvider).state.loop(
                'sounds/title.mp3',
                isNotification: true,
                volume: 0,
              );
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // timerを止める
    context.read(timerCancelFlgProvider).state = true;

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read(bgmProvider).state.pause();
      // context.read(subTimeStopFlgProvider).state = true;
    } else if (state == AppLifecycleState.resumed) {
      context.read(bgmProvider).state.resume();
      // context.read(subTimeStopFlgProvider).state = false;
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

    return MaterialApp(
      title: '水平思考対戦',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        canvasColor: Colors.grey.shade100,
        fontFamily: 'KiwiMaru',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
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
          builder: (ctx) => TitleScreen(),
        );
      },
    );
  }
}
