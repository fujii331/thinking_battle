import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/widgets/common/comment_modal.widget.dart';
import 'package:thinking_battle/widgets/common/loading_modal.widget.dart';

Future signUp(
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

    Navigator.pop(context);

    // TODO 遊び方にとぶ
    await Navigator.of(context).pushReplacementNamed(
      ModeSelectScreen.routeName,
    );
  } catch (e) {
    buttonPressedState.value = false;
    Navigator.pop(context);
    // ユーザー登録に失敗した場合
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      showCloseIcon: true,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      body: const CommentModal(
        topText: '読み込み失敗！',
        secondText: 'データ通信に失敗しました。\n電波の良いところで再度お試しください。',
      ),
    ).show();
  }
}

Future login(
  BuildContext context,
  ValueNotifier<bool> buttonPressedState,
) async {
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
    // チャット画面に遷移＋ログイン画面を破棄
    await Navigator.of(context).pushReplacementNamed(
      ModeSelectScreen.routeName,
    );
  } catch (e) {
    // ログインに失敗した場合
    buttonPressedState.value = false;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      showCloseIcon: true,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      body: const CommentModal(
        topText: '読み込み失敗！',
        secondText: 'データ通信に失敗しました。\n電波の良いところで再度お試しください。',
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
