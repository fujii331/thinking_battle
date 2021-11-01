import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/stamps.dart';
import 'package:thinking_battle/models/stamp.model.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/common/stamp_get.widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future checkStamp(
  BuildContext context,
  SharedPreferences prefs,
  int actionNumber,
  AudioCache soundEffect,
  double seVolume,
) async {
  List<String> stampList = context.read(stampListProvider).state;
  final List<String> messageIdsList =
      context.read(messageIdsListProvider).state;
  final List<String> imageNumberList =
      context.read(imageNumberListProvider).state;
  final List<String> cardNumberList =
      context.read(cardNumberListProvider).state;

  int itemNumber = 0;
  String title = '';
  String title2 = '';
  int patternNumber = 0;
  String message = '';
  int nextActionNumber = 0;

  if (actionNumber == 1) {
    // ログイン判定
    final int loginStampValue = int.parse(stampList[0]);
    final List<Stamp> loginStampJudge = stamps[0];
    final int loginDays = context.read(loginDaysProvider).state;

    if (loginStampValue == 0 && loginDays >= loginStampJudge[0].needCount) {
      // ガチャチケット1枚獲得
      context.read(gachaTicketProvider).state += 1;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      title = 'ログイン日数' + loginStampJudge[0].needCount.toString() + '日達成';
      title2 = loginStampJudge[0].reward + '！';
      patternNumber = 4;

      // スタンプ更新
      stampList[0] = (loginStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 1;
    } else if (loginStampValue == 1 &&
        loginDays >= loginStampJudge[1].needCount) {
      // メッセージ「orz」獲得
      itemNumber = 26;
      messageIdsList.add(itemNumber.toString());
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(messageIdsListProvider).state = messageIdsList;
      prefs.setStringList('messageIdsList', messageIdsList);
      title = 'ログイン日数' + loginStampJudge[1].needCount.toString() + '日達成';
      title2 = loginStampJudge[1].reward + '！';
      patternNumber = 3;

      // スタンプ更新
      stampList[0] = (loginStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 1;
    } else if (loginStampValue == 2 &&
        loginDays >= loginStampJudge[2].needCount) {
      // アイコン「きょうりゅうくん」獲得
      itemNumber = 1001;
      imageNumberList.add(itemNumber.toString());
      imageNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(imageNumberListProvider).state = imageNumberList;
      prefs.setStringList('imageNumberList', imageNumberList);
      title = 'ログイン日数' + loginStampJudge[2].needCount.toString() + '日達成';
      title2 = loginStampJudge[2].reward + '！';
      patternNumber = 1;

      // スタンプ更新
      stampList[0] = (loginStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 1;
    } else if (loginStampValue == 3 &&
        loginDays >= loginStampJudge[3].needCount) {
      // テーマ「パステルリーフ」獲得
      itemNumber = 1001;
      cardNumberList.add(itemNumber.toString());
      cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(cardNumberListProvider).state = cardNumberList;
      prefs.setStringList('cardNumberList', cardNumberList);

      title = 'ログイン日数' + loginStampJudge[3].needCount.toString() + '日達成';
      title2 = loginStampJudge[3].reward + '！';
      patternNumber = 2;

      // スタンプ更新
      stampList[0] = (loginStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 1;
    } else if (loginStampValue == 4 &&
        loginDays >= loginStampJudge[4].needCount) {
      // 10GP獲得
      context.read(gachaPointProvider).state += 10;
      prefs.setInt('gachaPoint', context.read(gachaPointProvider).state);
      title = 'ログイン日数' + loginStampJudge[4].needCount.toString() + '日達成';
      title2 = loginStampJudge[4].reward + '！';
      message = '好きなアイテムと交換しよう！';

      // スタンプ更新
      stampList[0] = (loginStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 1;
    }
  } else if (actionNumber == 2 || actionNumber == 4) {
    // 対戦後判定
    final int matchedCountStampValue = int.parse(stampList[1]);
    final int winCountStampValue = int.parse(stampList[2]);
    final int maxRateStampValue = int.parse(stampList[3]);
    final int skillUseCountStampValue = int.parse(stampList[4]);

    final List<Stamp> matchedCountStampJudge = stamps[1];
    final List<Stamp> winCountStampJudge = stamps[2];
    final List<Stamp> maxRateStampJudge = stamps[3];
    final List<Stamp> skillUseCountStampJudge = stamps[4];

    final int matchedCount = context.read(matchedCountProvider).state;
    final int winCount = context.read(winCountProvider).state;
    final double maxRate = context.read(maxRateProvider).state;
    final int skillUseCount = context.read(skillUseCountProvider).state;

    if (matchedCountStampValue == 0 &&
        matchedCount >= matchedCountStampJudge[0].needCount) {
      // スキル「嘘つき」を解放
      final List<String> settableSkillsList =
          context.read(settableSkillsListProvider).state;

      settableSkillsList.add('4');
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(settableSkillsListProvider).state = settableSkillsList;
      prefs.setStringList('settableSkillsList', settableSkillsList);
      title = '対戦回数' + matchedCountStampJudge[0].needCount.toString() + '回達成';
      title2 = matchedCountStampJudge[0].reward + '！';
      message = '自分が行った質問の返答とは嘘の情報が相手に表示されるスキル。\n\n相手は答えを勘違いするはず！';

      // スタンプ更新
      stampList[1] = (matchedCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 2;
    } else if (matchedCountStampValue == 1 &&
        matchedCount >= matchedCountStampJudge[1].needCount) {
      final List<String> settableSkillsList =
          context.read(settableSkillsListProvider).state;

      // スキル「質問確認」を解放
      settableSkillsList.add('7');
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(settableSkillsListProvider).state = settableSkillsList;
      prefs.setStringList('settableSkillsList', settableSkillsList);
      title = '対戦回数' + matchedCountStampJudge[1].needCount.toString() + '回達成';
      title2 = matchedCountStampJudge[1].reward + '！';
      message = '質問情報が正しく表示されていないとき、1つだけ変な情報を正しく表示しなおす。\n\n怪しい質問を確認したい時に有効！';

      // スタンプ更新
      stampList[1] = (matchedCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 2;
    } else if (matchedCountStampValue == 2 &&
        matchedCount >= matchedCountStampJudge[2].needCount) {
      // メッセージ「百戦錬磨です」獲得
      itemNumber = 27;
      messageIdsList.add(itemNumber.toString());
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(messageIdsListProvider).state = messageIdsList;
      prefs.setStringList('messageIdsList', messageIdsList);

      title = '対戦回数' + matchedCountStampJudge[2].needCount.toString() + '回達成';
      title2 = matchedCountStampJudge[2].reward + '！';
      patternNumber = 3;

      // スタンプ更新
      stampList[1] = (matchedCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 2;
    } else if (matchedCountStampValue == 3 &&
        matchedCount >= matchedCountStampJudge[3].needCount) {
      // アイコン「ホラーパンプキン」獲得
      itemNumber = 1002;
      imageNumberList.add(itemNumber.toString());
      imageNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(imageNumberListProvider).state = imageNumberList;
      prefs.setStringList('imageNumberList', imageNumberList);

      title = '対戦回数' + matchedCountStampJudge[3].needCount.toString() + '回達成';
      title2 = matchedCountStampJudge[3].reward + '！';
      patternNumber = 1;

      // スタンプ更新
      stampList[1] = (matchedCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (matchedCountStampValue == 4 &&
        matchedCount >= matchedCountStampJudge[4].needCount) {
      // テーマ「きれいな夜空」獲得
      itemNumber = 1002;
      cardNumberList.add(itemNumber.toString());
      cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(cardNumberListProvider).state = cardNumberList;
      prefs.setStringList('cardNumberList', cardNumberList);

      title = '対戦回数' + matchedCountStampJudge[4].needCount.toString() + '回達成';
      title2 = matchedCountStampJudge[4].reward + '！';
      patternNumber = 2;

      // スタンプ更新
      stampList[1] = (matchedCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    }
    // 勝利回数判定
    else if (winCountStampValue == 0 &&
        winCount >= winCountStampJudge[0].needCount) {
      // ガチャチケット1枚獲得
      context.read(gachaTicketProvider).state += 1;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      title = '勝利回数' + winCountStampJudge[0].needCount.toString() + '回達成';
      title2 = winCountStampJudge[0].reward + '！';
      patternNumber = 4;

      // スタンプ更新
      stampList[2] = (winCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (winCountStampValue == 1 &&
        winCount >= winCountStampJudge[1].needCount) {
      final List<String> settableSkillsList =
          context.read(settableSkillsListProvider).state;

      // スキル「質問サーチ」を解放
      settableSkillsList.add('5');
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(settableSkillsListProvider).state = settableSkillsList;
      prefs.setStringList('settableSkillsList', settableSkillsList);
      title = '勝利回数' + winCountStampJudge[1].needCount.toString() + '回達成';
      title2 = winCountStampJudge[1].reward + '！';
      message = '質問情報が正しく表示されていないとき、すべての変な情報を正しく表示しなおす。\n\n情報をスッキリさせたいときに有効！';

      // スタンプ更新
      stampList[2] = (winCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (winCountStampValue == 2 &&
        winCount >= winCountStampJudge[2].needCount) {
      // ガチャチケット2枚獲得
      context.read(gachaTicketProvider).state += 2;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      title = '勝利回数' + winCountStampJudge[2].needCount.toString() + '回達成';
      title2 = winCountStampJudge[2].reward + '！';
      patternNumber = 4;

      // スタンプ更新
      stampList[2] = (winCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (winCountStampValue == 3 &&
        winCount >= winCountStampJudge[3].needCount) {
      // テーマ「トライアングルゾーン」獲得
      itemNumber = 1003;
      cardNumberList.add(itemNumber.toString());
      cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(cardNumberListProvider).state = cardNumberList;
      prefs.setStringList('cardNumberList', cardNumberList);

      title = '勝利回数' + winCountStampJudge[3].needCount.toString() + '回達成';
      title2 = winCountStampJudge[3].reward + '！';
      patternNumber = 2;

      // スタンプ更新
      stampList[2] = (winCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (winCountStampValue == 4 &&
        winCount >= winCountStampJudge[4].needCount) {
      // アイコン「マジックパンプキン」獲得
      itemNumber = 1003;
      imageNumberList.add(itemNumber.toString());
      imageNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(imageNumberListProvider).state = imageNumberList;
      prefs.setStringList('imageNumberList', imageNumberList);

      title = '勝利回数' + winCountStampJudge[4].needCount.toString() + '回達成';
      title2 = winCountStampJudge[4].reward + '！';
      patternNumber = 1;

      // スタンプ更新
      stampList[2] = (winCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    }
    // 最大レート判定
    else if (maxRateStampValue == 0 &&
        maxRate >= maxRateStampJudge[0].needCount) {
      // スキル「トラップ」を解放
      final List<String> settableSkillsList =
          context.read(settableSkillsListProvider).state;

      settableSkillsList.add('8');
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(settableSkillsListProvider).state = settableSkillsList;
      prefs.setStringList('settableSkillsList', settableSkillsList);
      title = '最大レート' + maxRateStampJudge[0].needCount.toString() + '到達';
      title2 = maxRateStampJudge[0].reward + '！';
      message = '次に相手が質問を行った時、質問に対する嘘の返答が相手には表示される。\n\n相手が何かやろうとしているときに使える！？';

      // スタンプ更新
      stampList[3] = (maxRateStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (maxRateStampValue == 1 &&
        maxRate >= maxRateStampJudge[1].needCount) {
      // メッセージ「勝利の方程式だ」獲得
      itemNumber = 28;
      messageIdsList.add(itemNumber.toString());
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(messageIdsListProvider).state = messageIdsList;
      prefs.setStringList('messageIdsList', messageIdsList);

      title = '最大レート' + maxRateStampJudge[1].needCount.toString() + '到達';
      title2 = maxRateStampJudge[1].reward + '！';
      patternNumber = 3;

      // スタンプ更新
      stampList[3] = (maxRateStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (maxRateStampValue == 2 &&
        maxRate >= maxRateStampJudge[2].needCount) {
      // アイコン「ウルフ」獲得
      itemNumber = 1004;
      imageNumberList.add(itemNumber.toString());
      imageNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(imageNumberListProvider).state = imageNumberList;
      prefs.setStringList('imageNumberList', imageNumberList);

      title = '最大レート' + maxRateStampJudge[2].needCount.toString() + '到達';
      title2 = maxRateStampJudge[2].reward + '！';
      patternNumber = 1;

      // スタンプ更新
      stampList[3] = (maxRateStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (maxRateStampValue == 3 &&
        maxRate >= maxRateStampJudge[3].needCount) {
      // テーマ「ブラックロック」獲得
      itemNumber = 1004;
      cardNumberList.add(itemNumber.toString());
      cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(cardNumberListProvider).state = cardNumberList;
      prefs.setStringList('cardNumberList', cardNumberList);

      title = '最大レート' + maxRateStampJudge[3].needCount.toString() + '到達';
      title2 = maxRateStampJudge[3].reward + '！';
      patternNumber = 2;

      // スタンプ更新
      stampList[3] = (maxRateStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (maxRateStampValue == 4 &&
        maxRate >= maxRateStampJudge[4].needCount) {
      // メッセージ「私は強い」獲得
      itemNumber = 29;
      messageIdsList.add(itemNumber.toString());
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(messageIdsListProvider).state = messageIdsList;
      prefs.setStringList('messageIdsList', messageIdsList);

      title = '最大レート' + maxRateStampJudge[4].needCount.toString() + '到達';
      title2 = maxRateStampJudge[4].reward + '！';
      patternNumber = 3;

      // スタンプ更新
      stampList[3] = (maxRateStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } // スキル使用回数判定
    else if (skillUseCountStampValue == 0 &&
        skillUseCount >= skillUseCountStampJudge[0].needCount) {
      // ガチャチケット1枚獲得
      context.read(gachaTicketProvider).state += 1;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      title =
          'スキル使用回数' + skillUseCountStampJudge[0].needCount.toString() + '到達';
      title2 = skillUseCountStampJudge[0].reward + '！';
      patternNumber = 4;

      // スタンプ更新
      stampList[4] = (skillUseCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (skillUseCountStampValue == 1 &&
        skillUseCount >= skillUseCountStampJudge[1].needCount) {
      // スキル「SP溜め」を解放
      final List<String> settableSkillsList =
          context.read(settableSkillsListProvider).state;

      settableSkillsList.add('6');
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(settableSkillsListProvider).state = settableSkillsList;
      prefs.setStringList('settableSkillsList', settableSkillsList);

      title =
          'スキル使用回数' + skillUseCountStampJudge[1].needCount.toString() + '到達';
      title2 = skillUseCountStampJudge[1].reward + '！';
      message = '一定時間SPが溜まりやすくなるスキル。\nスキルをたくさん使いたい人におすすめ！';

      // スタンプ更新
      stampList[4] = (skillUseCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (skillUseCountStampValue == 2 &&
        skillUseCount >= skillUseCountStampJudge[2].needCount) {
      // アイコン「きゅうりマン」獲得
      itemNumber = 1005;
      imageNumberList.add(itemNumber.toString());
      imageNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(imageNumberListProvider).state = imageNumberList;
      prefs.setStringList('imageNumberList', imageNumberList);

      title =
          'スキル使用回数' + skillUseCountStampJudge[2].needCount.toString() + '到達';
      title2 = skillUseCountStampJudge[2].reward + '！';
      patternNumber = 1;

      // スタンプ更新
      stampList[4] = (skillUseCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (skillUseCountStampValue == 3 &&
        skillUseCount >= skillUseCountStampJudge[3].needCount) {
      //テーマ「オレンジキューブ」獲得
      itemNumber = 1005;
      cardNumberList.add(itemNumber.toString());
      cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(cardNumberListProvider).state = cardNumberList;
      prefs.setStringList('cardNumberList', cardNumberList);

      title =
          'スキル使用回数' + skillUseCountStampJudge[3].needCount.toString() + '到達';
      title2 = skillUseCountStampJudge[3].reward + '！';
      patternNumber = 2;

      // スタンプ更新
      stampList[4] = (skillUseCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (skillUseCountStampValue == 4 &&
        skillUseCount >= skillUseCountStampJudge[4].needCount) {
      // メッセージ「スキル使うけど許してね」獲得
      itemNumber = 30;
      messageIdsList.add(itemNumber.toString());
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));
      context.read(messageIdsListProvider).state = messageIdsList;
      prefs.setStringList('messageIdsList', messageIdsList);

      title =
          'スキル使用回数' + skillUseCountStampJudge[4].needCount.toString() + '到達';
      title2 = skillUseCountStampJudge[4].reward + '！';
      patternNumber = 3;

      // スタンプ更新
      stampList[4] = (skillUseCountStampValue + 1).toString();
      context.read(stampListProvider).state = stampList;
      nextActionNumber = 4;
    } else if (actionNumber == 4) {
      final List returnValueList = checkIconThemeCountStamp(
        context,
        prefs,
        stampList,
        imageNumberList,
        cardNumberList,
      );

      // 値を更新
      if (returnValueList[5] != 0) {
        itemNumber = returnValueList[0];
        title = returnValueList[1];
        title2 = returnValueList[2];
        patternNumber = returnValueList[3];
        message = returnValueList[4];
        nextActionNumber = returnValueList[5];
        stampList = returnValueList[6];
      }
    }
  } else if (actionNumber == 3) {
    final List returnValueList = checkIconThemeCountStamp(
      context,
      prefs,
      stampList,
      imageNumberList,
      cardNumberList,
    );

    // 値を更新
    if (returnValueList[5] != 0) {
      itemNumber = returnValueList[0];
      title = returnValueList[1];
      title2 = returnValueList[2];
      patternNumber = returnValueList[3];
      message = returnValueList[4];
      nextActionNumber = returnValueList[5];
      stampList = returnValueList[6];
    }
  }

  if (nextActionNumber != 0) {
    context.read(stampListProvider).state = stampList;
    prefs.setStringList('stampList', stampList);

    soundEffect.play(
      'sounds/new_item.mp3',
      isNotification: true,
      volume: seVolume,
    );

    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      showCloseIcon: false,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: StampGet(
        screenContext: context,
        prefs: prefs,
        itemNumber: itemNumber,
        title: title,
        title2: title2,
        patternNumber: patternNumber,
        message: message,
        soundEffect: soundEffect,
        seVolume: seVolume,
        nextActionNumber: nextActionNumber,
      ),
    ).show();
  }
}

List checkIconThemeCountStamp(
  BuildContext context,
  SharedPreferences prefs,
  List<String> stampList,
  List<String> imageNumberList,
  List<String> cardNumberList,
) {
  int itemNumber = 0;
  String title = '';
  String title2 = '';
  int patternNumber = 0;
  String message = '';
  int nextActionNumber = 0;

  // アイコン・テーマ数判定
  final int iconThemeCountStampValue = int.parse(stampList[5]);
  final List<Stamp> iconThemeCountStampJudge = stamps[5];
  final int iconThemeCount = imageNumberList.length + cardNumberList.length;

  if (iconThemeCountStampValue == 0 &&
      iconThemeCount >= iconThemeCountStampJudge[0].needCount) {
    // ガチャチケット1枚獲得
    context.read(gachaTicketProvider).state += 1;
    prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
    title =
        'アイコン・テーマ数' + iconThemeCountStampJudge[0].needCount.toString() + '個達成';
    title2 = iconThemeCountStampJudge[0].reward + '！';
    patternNumber = 4;

    // スタンプ更新
    stampList[5] = (iconThemeCountStampValue + 1).toString();
    context.read(stampListProvider).state = stampList;

    nextActionNumber = 3;
  } else if (iconThemeCountStampValue == 1 &&
      iconThemeCount >= iconThemeCountStampJudge[1].needCount) {
    // 5GP獲得
    context.read(gachaPointProvider).state += 5;
    prefs.setInt('gachaPoint', context.read(gachaPointProvider).state);
    title =
        'アイコン・テーマ数' + iconThemeCountStampJudge[1].needCount.toString() + '個達成';
    title2 = iconThemeCountStampJudge[1].reward + '！';
    message = '好きなアイテムと交換しよう！';

    // スタンプ更新
    stampList[5] = (iconThemeCountStampValue + 1).toString();
    context.read(stampListProvider).state = stampList;
    nextActionNumber = 3;
  } else if (iconThemeCountStampValue == 2 &&
      iconThemeCount >= iconThemeCountStampJudge[2].needCount) {
    // テーマ「メカニカルエレキ」獲得
    itemNumber = 1006;
    cardNumberList.add(itemNumber.toString());
    cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
    context.read(cardNumberListProvider).state = cardNumberList;
    prefs.setStringList('cardNumberList', cardNumberList);

    title =
        'アイコン・テーマ数' + iconThemeCountStampJudge[2].needCount.toString() + '個達成';
    title2 = iconThemeCountStampJudge[2].reward + '！';
    patternNumber = 2;

    // スタンプ更新
    stampList[5] = (iconThemeCountStampValue + 1).toString();
    context.read(stampListProvider).state = stampList;
    nextActionNumber = 3;
  } else if (iconThemeCountStampValue == 3 &&
      iconThemeCount >= iconThemeCountStampJudge[3].needCount) {
    // アイコン「どらきゅらさん」獲得
    itemNumber = 1006;
    imageNumberList.add(itemNumber.toString());
    imageNumberList.sort((a, b) => int.parse(a) - int.parse(b));
    context.read(imageNumberListProvider).state = imageNumberList;
    prefs.setStringList('imageNumberList', imageNumberList);

    title =
        'アイコン・テーマ数' + iconThemeCountStampJudge[3].needCount.toString() + '個達成';
    title2 = iconThemeCountStampJudge[3].reward + '！';
    patternNumber = 1;

    // スタンプ更新
    stampList[5] = (iconThemeCountStampValue + 1).toString();
    context.read(stampListProvider).state = stampList;
    nextActionNumber = 3;
  } else if (iconThemeCountStampValue == 4 &&
      iconThemeCount >= iconThemeCountStampJudge[4].needCount) {
    // テーマ「異空間」獲得
    itemNumber = 1007;
    cardNumberList.add(itemNumber.toString());
    cardNumberList.sort((a, b) => int.parse(a) - int.parse(b));
    context.read(cardNumberListProvider).state = cardNumberList;
    prefs.setStringList('cardNumberList', cardNumberList);
    title =
        'アイコン・テーマ数' + iconThemeCountStampJudge[4].needCount.toString() + '個達成';
    title2 = iconThemeCountStampJudge[4].reward + '！';
    patternNumber = 2;

    // スタンプ更新
    stampList[5] = (iconThemeCountStampValue + 1).toString();
    context.read(stampListProvider).state = stampList;
    nextActionNumber = 3;
  }

  return [
    itemNumber,
    title,
    title2,
    patternNumber,
    message,
    nextActionNumber,
    stampList
  ];
}
