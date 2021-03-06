import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_game_system.screen.dart';
import 'package:thinking_battle/widgets/common/comment_modal.widget.dart';
import 'package:thinking_battle/widgets/common/loading_modal.widget.dart';

Future signUp(
  BuildContext context,
  ValueNotifier<bool> buttonPressedState,
  ValueNotifier<bool> judgeFlgState,
) async {
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingModal();
    },
  );

  try {
    // メール/パスワードでユーザー登録
    final FirebaseAuth auth = FirebaseAuth.instance;

    final String email = randomString(16) + '@example.com';
    final String password = randomString(16);

    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // ユーザー登録に成功した場合

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', email);
    prefs.setString('password', password);

    context.read(loginIdProvider).state = email;

    Navigator.pop(context);

    Navigator.of(context).pushReplacementNamed(
      TutorialGameSystemScreen.routeName,
      arguments: true,
    );
  } catch (e) {
    // ユーザー登録に失敗した場合

    buttonPressedState.value = false;
    judgeFlgState.value = true;
    Navigator.pop(context);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      showCloseIcon: true,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: const CommentModal(
        topText: '読み込み失敗！',
        secondText: 'データ通信に失敗しました。\n電波の良いところで再度お試しください。',
        closeButtonFlg: true,
      ),
    ).show();
  }
}

Future login(
  BuildContext context,
  ValueNotifier<bool> buttonPressedState,
) async {
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingModal();
    },
  );

  try {
    // メール/パスワードでログイン
    final FirebaseAuth auth = FirebaseAuth.instance;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');

    await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    // ログインに成功した場合
    Navigator.pop(context);

    Navigator.of(context).pushReplacementNamed(
      ModeSelectScreen.routeName,
    );
  } catch (e) {
    // ログインに失敗した場合
    buttonPressedState.value = false;
    Navigator.pop(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      showCloseIcon: true,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: const CommentModal(
        topText: '読み込み失敗！',
        secondText: 'データ通信に失敗しました。\n電波の良いところで再度お試しください。',
        closeButtonFlg: true,
      ),
    ).show();
  }
}

String randomString(int length) {
  const _randomChars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  const _charsLength = _randomChars.length;

  final rand = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}
