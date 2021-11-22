import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/skills.dart';
import 'dart:math';

import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/send_content.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/screens/game_finish.screen.dart';
import 'package:thinking_battle/services/admob/interstitial_action.service.dart';
import 'package:thinking_battle/services/game_playing/cpu_action.service.dart';
import 'package:thinking_battle/services/game_playing/update_rate.service.dart';

Future turnAction(
  BuildContext context,
  SendContent sendContent,
  bool myTurnFlg,
  ScrollController scrollController,
  AudioCache soundEffect,
  double seVolume,
  StreamSubscription<DocumentSnapshot>? rivalListenSubscription,
) async {
  await Future.delayed(
    const Duration(milliseconds: 500),
  );

  // 表示リスト
  List<DisplayContent> displayContentList =
      context.read(displayContentListProvider).state;

  // 全質問
  final List<Question> allQuestions = [
    ...context.read(allQuestionsProvider).state
  ];

  // スクロール量決定用
  final bool widthOk = MediaQuery.of(context).size.width > 350;
  final double fontSize = widthOk ? 16 : 14;
  final double restrictWidth = myTurnFlg
      ? MediaQuery.of(context).size.width * .56
      : MediaQuery.of(context).size.width * .47;

  // 画面上の表示を消す
  if (myTurnFlg) {
    context.read(displayMyturnSetFlgProvider).state = false;
    // 自分のターンの場合、質問リストに出てきたものを既出質問に追加する
    context.read(alreadyseenQuestionsProvider).state += context
        .read(selectableQuestionsProvider)
        .state
        .where((Question question) => question.id != sendContent.questionId)
        .toList();
  } else {
    context.read(displayRivalturnSetFlgProvider).state = false;
  }

  // 質問
  if (sendContent.questionId != 0) {
    // 質問対象
    final Question targetQuestion = allQuestions
        .where((question) => question.id == sendContent.questionId)
        .toList()
        .first;

    allQuestions.removeWhere(
        (Question question) => question.id == sendContent.questionId);

    // 質問一覧から削除
    context.read(allQuestionsProvider).state = allQuestions;

    final DisplayContent displayContent = DisplayContent(
      content: targetQuestion.asking,
      reply: targetQuestion.reply,
      answerFlg: false,
      myTurnFlg: myTurnFlg,
      skillIds: sendContent.skillIds,
      displayList: [],
      importance: targetQuestion.importance,
      specialMessage: '',
      messageId: sendContent.messageId,
    );

    // 表示リストに追加する
    displayContentList.add(displayContent);
    context.read(displayContentListProvider).state = displayContentList;

    if (sendContent.messageId != 0) {
      // メッセージ表示
      soundEffect.play(
        'sounds/rival_message.mp3',
        isNotification: true,
        volume: seVolume,
      );

      displayContentList.last.displayList.add(0);
      context.read(displayContentListProvider).state = displayContentList;

      if (myTurnFlg) {
        // メッセージを初期化
        context.read(selectMessageIdProvider).state = 0;
        // メッセージ時間を初期化
        context.read(afterMessageTimeProvider).state = 60;
      } else if (context.read(trainingStatusProvider).state >= 3) {
        // メッセージ時間を初期化
        context.read(afterRivalMessageTimeProvider).state = 60;
      }

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      scrollToBottom(
        context,
        scrollController,
      );

      await Future.delayed(
        const Duration(milliseconds: 600),
      );
    }

    final List<int> displaySkillIds = sendContent.skillIds
        .where(
          (skill) => (myTurnFlg == true || ![4, 8].contains(skill)),
        )
        .toList();

    // 相手ターンの場合、嘘つきとトラップを考慮するため別でスキルポイントを減少させる
    if (!myTurnFlg) {
      for (int skillId in sendContent.skillIds) {
        context.read(enemySkillPointProvider).state -=
            skillSettings[skillId - 1].skillPoint;
      }
    }

    if (myTurnFlg) {
      if (context.read(enemyTrapCountProvider).state > 0) {
        // 自分のターンでトラップが仕掛けられていた場合、表示を変更するためのスキルを追加する
        displayContentList.last.skillIds.add(108);
        context.read(enemyTrapCountProvider).state -= 1;
      }
      if (sendContent.skillIds.contains(8)) {
        // 自分のターンにトラップを使った場合、トラップカウントをプラスする
        context.read(myTrapCountProvider).state += 1;
      }
    } else {
      if (context.read(myTrapCountProvider).state > 0) {
        // 相手のターンでトラップが仕掛けられていた場合、表示を変更するためのスキルを追加する
        displayContentList.last.skillIds.add(108);
        context.read(myTrapCountProvider).state -= 1;
      }
      if (sendContent.skillIds.contains(8)) {
        // 自分のターンにトラップを使った場合、トラップカウントをプラスする
        context.read(enemyTrapCountProvider).state += 1;
      }
    }

    for (int i = 0; i < displaySkillIds.length; i++) {
      soundEffect.play(
        'sounds/skill.mp3',
        isNotification: true,
        volume: seVolume,
      );

      // 自分のターンの場合、スキル表示と同時に順番にスキルポイントを減らす
      if (myTurnFlg) {
        context.read(currentSkillPointProvider).state -=
            skillSettings[displaySkillIds[i] - 1].skillPoint;
        // スキル使用回数を増加する
        context.read(skillUseCountInGameProvider).state += 1;
      }

      displayContentList.last.displayList.add(0);
      context.read(displayContentListProvider).state = displayContentList;

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      scrollToBottom(
        context,
        scrollController,
      );

      if (displaySkillIds[i] == 5) {
        int changedCount = 0;
        await Future.delayed(
          const Duration(milliseconds: 400),
        );

        context.read(displayQuestionResearchProvider).state = 1;
        await Future.delayed(
          const Duration(milliseconds: 200),
        );
        context.read(animationQuestionResearchProvider).state = true;

        soundEffect.play(
          'sounds/question_research.mp3',
          isNotification: true,
          volume: seVolume,
        );

        await Future.delayed(
          const Duration(milliseconds: 2000),
        );

        context.read(displayContentListProvider).state =
            displayContentList.map((displaycontent) {
          if (displaycontent.myTurnFlg != myTurnFlg &&
              (displaycontent.skillIds.contains(1) ||
                  displaycontent.skillIds.contains(4) ||
                  displaycontent.skillIds.contains(8))) {
            changedCount++;
            final changedSkillIds = displaycontent.skillIds.map((skillId) {
              return (skillId == 1 || skillId == 4 || skillId == 8)
                  ? -skillId
                  : skillId;
            }).toList();
            return DisplayContent(
              content: displaycontent.content,
              reply: displaycontent.reply,
              answerFlg: displaycontent.answerFlg,
              myTurnFlg: displaycontent.myTurnFlg,
              skillIds: changedSkillIds,
              displayList: [0, 0, 0, 0, 0, 0, 0],
              importance: displaycontent.importance,
              specialMessage: displaycontent.specialMessage,
              messageId: displaycontent.messageId,
            );
          } else if (displaycontent.myTurnFlg == myTurnFlg &&
              displaycontent.skillIds.contains(108)) {
            final changedSkillIds = displaycontent.skillIds.map((skillId) {
              return (skillId == 108) ? -skillId : skillId;
            }).toList();
            return DisplayContent(
              content: displaycontent.content,
              reply: displaycontent.reply,
              answerFlg: displaycontent.answerFlg,
              myTurnFlg: displaycontent.myTurnFlg,
              skillIds: changedSkillIds,
              displayList: displaycontent.displayList,
              importance: displaycontent.importance,
              specialMessage: displaycontent.specialMessage,
              messageId: displaycontent.messageId,
            );
          } else {
            return displaycontent;
          }
        }).toList();

        context.read(displayContentListProvider).state.last = DisplayContent(
          content: displayContentList.last.content,
          reply: displayContentList.last.reply,
          answerFlg: displayContentList.last.answerFlg,
          myTurnFlg: displayContentList.last.myTurnFlg,
          skillIds: displayContentList.last.skillIds,
          displayList: displayContentList.last.displayList,
          importance: displayContentList.last.importance,
          specialMessage: changedCount == 0
              ? '質問サーチ (修正なし)'
              : '質問サーチ (' + changedCount.toString() + 'つ修正)',
          messageId: displayContentList.last.messageId,
        );

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        if (changedCount > 0) {
          scrollToBottom(
            context,
            scrollController,
          );
        }

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        context.read(animationQuestionResearchProvider).state = false;
        await Future.delayed(
          const Duration(milliseconds: 600),
        );
        context.read(displayQuestionResearchProvider).state = 0;
        displayContentList = context.read(displayContentListProvider).state;
      } else if (displaySkillIds[i] == 7) {
        bool changedFlg = false;
        await Future.delayed(
          const Duration(milliseconds: 470),
        );

        context.read(displayQuestionResearchProvider).state = 2;
        await Future.delayed(
          const Duration(milliseconds: 200),
        );
        context.read(animationQuestionResearchProvider).state = true;

        soundEffect.play(
          'sounds/question_research.mp3',
          isNotification: true,
          volume: seVolume,
        );

        await Future.delayed(
          const Duration(milliseconds: 2000),
        );

        // 変更する番号を取得
        final int changeNo = displayContentList.lastIndexWhere(
          (displaycontent) =>
              displaycontent.myTurnFlg != myTurnFlg &&
              (displaycontent.skillIds.contains(1) ||
                  displaycontent.skillIds.contains(4) ||
                  displaycontent.skillIds.contains(8)),
        );

        if (changeNo != -1) {
          changedFlg = true;
          final changeContent = displayContentList[changeNo];
          final changedSkillIds = changeContent.skillIds.map((skillId) {
            return (skillId == 1 || skillId == 4 || skillId == 8)
                ? -skillId
                : skillId;
          }).toList();

          displayContentList[changeNo] = DisplayContent(
            content: changeContent.content,
            reply: changeContent.reply,
            answerFlg: changeContent.answerFlg,
            myTurnFlg: changeContent.myTurnFlg,
            skillIds: changedSkillIds,
            displayList: [0, 0, 0, 0, 0, 0, 0],
            importance: changeContent.importance,
            specialMessage: changeContent.specialMessage,
            messageId: changeContent.messageId,
          );

          // トラップを更新した場合は次の自分の質問分も修正
          if (changedSkillIds.contains(-8)) {
            // 変更する番号を取得
            final int withChangeNo = displayContentList.lastIndexWhere(
              (displaycontent) =>
                  displaycontent.myTurnFlg == myTurnFlg &&
                  displaycontent.skillIds.contains(108),
            );
            final withChangeContent = displayContentList[withChangeNo];
            final withChangedSkillIds =
                withChangeContent.skillIds.map((skillId) {
              return (skillId == 108) ? -skillId : skillId;
            }).toList();

            displayContentList[withChangeNo] = DisplayContent(
              content: withChangeContent.content,
              reply: withChangeContent.reply,
              answerFlg: withChangeContent.answerFlg,
              myTurnFlg: withChangeContent.myTurnFlg,
              skillIds: withChangedSkillIds,
              displayList: withChangeContent.displayList,
              importance: withChangeContent.importance,
              specialMessage: withChangeContent.specialMessage,
              messageId: withChangeContent.messageId,
            );
          }

          context.read(displayContentListProvider).state = displayContentList;
        }

        context.read(displayContentListProvider).state.last = DisplayContent(
          content: displayContentList.last.content,
          reply: displayContentList.last.reply,
          answerFlg: displayContentList.last.answerFlg,
          myTurnFlg: displayContentList.last.myTurnFlg,
          skillIds: displayContentList.last.skillIds,
          displayList: displayContentList.last.displayList,
          importance: displayContentList.last.importance,
          specialMessage: !changedFlg ? '質問確認 (修正なし)' : '質問確認 (1つ修正)',
          messageId: displayContentList.last.messageId,
        );

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        if (changedFlg) {
          scrollToBottom(
            context,
            scrollController,
          );
        }

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        context.read(animationQuestionResearchProvider).state = false;
        await Future.delayed(
          const Duration(milliseconds: 600),
        );
        context.read(displayQuestionResearchProvider).state = 0;
        displayContentList = context.read(displayContentListProvider).state;
      }

      await Future.delayed(
        const Duration(milliseconds: 650),
      );
    }

    // 質問表示
    soundEffect.play(
      'sounds/got_message.mp3',
      isNotification: true,
      volume: seVolume,
    );

    displayContentList.last.displayList.add(0);
    context.read(displayContentListProvider).state = displayContentList;

    if (myTurnFlg) {
      // 解答禁止状態の場合、解除する
      if (context.read(answerFailedFlgProvider).state) {
        context.read(answerFailedFlgProvider).state = false;
      }

      // 強制質問状態の場合、解除する
      if (context.read(forceQuestionFlgProvider).state) {
        context.read(forceQuestionFlgProvider).state = false;
      }

      // SPチャージ
      if (sendContent.skillIds.contains(6)) {
        context.read(spChargeTurnProvider).state = 4;
      }

      final spChargeTurn = context.read(spChargeTurnProvider).state;

      // SP追加
      if (spChargeTurn > 0) {
        context.read(currentSkillPointProvider).state += 3;
        context.read(spChargeTurnProvider).state -= 1;
      } else {
        context.read(currentSkillPointProvider).state += 1;
      }
    } else {
      // 強制質問が実行された場合、設定する
      if (sendContent.skillIds.contains(3)) {
        context.read(forceQuestionFlgProvider).state = true;
      }

      final rivalSpChargeTurn = context.read(rivalSpChargeTurnProvider).state;

      // SPチャージ
      if (sendContent.skillIds.contains(6)) {
        context.read(spChargeTurnProvider).state = 4;
      }

      // SP追加
      if (rivalSpChargeTurn > 0) {
        context.read(enemySkillPointProvider).state += 3;
        context.read(rivalSpChargeTurnProvider).state -= 1;
      } else {
        context.read(enemySkillPointProvider).state += 1;
      }
    }

    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    scrollToBottom(
      context,
      scrollController,
    );

    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    // 返答表示
    soundEffect.play(
      'sounds/reply.mp3',
      isNotification: true,
      volume: seVolume,
    );

    displayContentList.last.displayList.add(0);
    context.read(displayContentListProvider).state = displayContentList;
  } else {
    // メッセージの表示
    if (sendContent.messageId != 0) {
      // メッセージ表示
      soundEffect.play(
        'sounds/rival_message.mp3',
        isNotification: true,
        volume: seVolume,
      );

      displayContentList.last.displayList.add(0);
      context.read(displayContentListProvider).state = displayContentList;

      if (myTurnFlg) {
        // メッセージを初期化
        context.read(selectMessageIdProvider).state = 0;
        // メッセージ時間を初期化
        context.read(afterMessageTimeProvider).state = 60;
      } else if (context.read(trainingStatusProvider).state >= 3) {
        // メッセージ時間を初期化
        context.read(afterRivalMessageTimeProvider).state = 60;
      }

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      scrollToBottom(
        context,
        scrollController,
      );

      await Future.delayed(
        const Duration(milliseconds: 600),
      );
    }

    // 正解判定
    final correctAnswerFlg =
        context.read(correctAnswersProvider).state.contains(sendContent.answer);

    if (correctAnswerFlg && !myTurnFlg) {
      // 負けた時の広告の読み込みを行う
      await interstitialLoading(
        context,
      );
    }

    final String answerText = '答えは' + sendContent.answer + 'だ！';

    // 解答実行
    final DisplayContent displayContent = DisplayContent(
      content: answerText,
      reply: '.',
      answerFlg: true,
      myTurnFlg: myTurnFlg,
      skillIds: [],
      displayList: [],
      importance: 0,
      specialMessage: '',
      messageId: sendContent.messageId,
    );

    // 表示リストに追加する
    displayContentList.add(displayContent);
    context.read(displayContentListProvider).state = displayContentList;

    // 解答表示
    soundEffect.play(
      'sounds/got_message.mp3',
      isNotification: true,
      volume: seVolume,
    );

    displayContentList.last.displayList.add(0);
    context.read(displayContentListProvider).state = displayContentList;

    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    scrollToBottom(
      context,
      scrollController,
    );

    await Future.delayed(
      const Duration(milliseconds: 1400),
    );

    for (int i = 0; i < 3; i++) {
      soundEffect.play(
        'sounds/waiting_answer.mp3',
        isNotification: true,
        volume: seVolume,
      );

      if (i > 0) {
        displayContentList.last = DisplayContent(
          content: answerText,
          reply: i == 1 ? '. .' : '. . .',
          answerFlg: true,
          myTurnFlg: myTurnFlg,
          skillIds: [],
          displayList: displayContentList.last.displayList,
          importance: 0,
          specialMessage: '',
          messageId: displayContentList.last.messageId,
        );
      } else {
        displayContentList.last.displayList.add(0);
      }
      context.read(displayContentListProvider).state = displayContentList;

      await Future.delayed(
        const Duration(milliseconds: 700),
      );
    }

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (correctAnswerFlg) {
      soundEffect.play(
        'sounds/correct_answer.mp3',
        isNotification: true,
        volume: seVolume,
      );
      if (context.read(friendMatchWordProvider).state == '' &&
          context.read(trainingStatusProvider).state != 1) {
        // レート計算
        await updateRate(
          context,
          myTurnFlg,
          context.read(trainingStatusProvider).state == 2,
        );
      }

      if (rivalListenSubscription != null) {
        rivalListenSubscription.cancel();
      }

      // 音楽停止し、新しい音楽の準備
      // 広告時に音を流さないためにここで先に設定する
      context.read(bgmProvider).state.stop();
      context.read(bgmProvider).state =
          await context.read(soundEffectProvider).state.loop(
                'sounds/title.mp3',
                volume: 0,
                isNotification: true,
              );

      if (!myTurnFlg) {
        // 広告を表示する
        showInterstitialAd(context);
        await Future.delayed(
          const Duration(milliseconds: 200),
        );
      }

      displayContentList.last = DisplayContent(
        content: displayContentList.last.content,
        reply: '正解!',
        answerFlg: true,
        myTurnFlg: myTurnFlg,
        skillIds: [],
        displayList: displayContentList.last.displayList,
        importance: 0,
        specialMessage: '',
        messageId: displayContentList.last.messageId,
      );
      context.read(displayContentListProvider).state = displayContentList;
      context.read(timerCancelFlgProvider).state = true;

      await Future.delayed(
        const Duration(milliseconds: 1300),
      );

      Navigator.of(context).pushReplacementNamed(
        GameFinishScreen.routeName,
        arguments: myTurnFlg,
      );
      return;
    } else {
      soundEffect.play(
        'sounds/fault.mp3',
        isNotification: true,
        volume: seVolume,
      );

      displayContentList.last = DisplayContent(
        content: displayContentList.last.content,
        reply: '残念!',
        answerFlg: true,
        myTurnFlg: myTurnFlg,
        skillIds: [],
        displayList: displayContentList.last.displayList,
        importance: 0,
        specialMessage: '',
        messageId: displayContentList.last.messageId,
      );
      context.read(displayContentListProvider).state = displayContentList;

      if (myTurnFlg) {
        // 次のターンの解答を禁止する
        context.read(answerFailedFlgProvider).state = true;
      }
    }
  }

  await Future.delayed(
    const Duration(milliseconds: 800),
  );

  if (allQuestions.length < 3) {
    // 広告の読み込みを行う
    await interstitialLoading(
      context,
    );
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 接続が切れた場合のレートを更新
    prefs.setDouble('failedRate', 0.0);

    // 質問無くなった宣言
    final DisplayContent displayContent = DisplayContent(
      content: 'もう質問ない...',
      reply: '終了！',
      answerFlg: false,
      myTurnFlg: !myTurnFlg,
      skillIds: [],
      displayList: [0],
      importance: 0,
      specialMessage: '',
      messageId: 0,
    );

    // 表示リストに追加する
    displayContentList.add(displayContent);
    context.read(displayContentListProvider).state = displayContentList;

    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    // 質問表示
    soundEffect.play(
      'sounds/got_message.mp3',
      isNotification: true,
      volume: seVolume,
    );

    scrollToBottom(
      context,
      scrollController,
    );

    if (rivalListenSubscription != null) {
      rivalListenSubscription.cancel();
    }
    context.read(timerCancelFlgProvider).state = true;

    await Future.delayed(
      const Duration(milliseconds: 1900),
    );

    // 音楽停止し、新しい音楽の準備
    // 広告時に音を流さないためにここで先に設定する
    context.read(bgmProvider).state.stop();
    context.read(bgmProvider).state =
        await context.read(soundEffectProvider).state.loop(
              'sounds/title.mp3',
              volume: 0,
              isNotification: true,
            );

    showInterstitialAd(context);

    Navigator.of(context).pushReplacementNamed(
      GameFinishScreen.routeName,
      arguments: null,
    );
    return;
  }

  // 初期化
  initializeAction(
    context,
    !myTurnFlg,
    [...allQuestions],
    soundEffect,
    seVolume,
    scrollController,
  );
}

void scrollToBottom(
  BuildContext context,
  ScrollController scrollController,
) {
  final bottomOffset = scrollController.position.maxScrollExtent;
  scrollController.animateTo(
    bottomOffset,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
  );
}

Future initializeAction(
  BuildContext context,
  bool nextMyTurnFlg,
  List<Question> allQuestions,
  AudioCache soundEffect,
  double seVolume,
  ScrollController scrollController,
) async {
  if (nextMyTurnFlg) {
    allQuestions.shuffle();
    // 既出質問IDs
    List<int> alreadyseenQuestionIds = context
        .read(alreadyseenQuestionsProvider)
        .state
        .map((alreadyseenQuestion) => alreadyseenQuestion.id)
        .toList();
    // 重要度1
    List<Question> importance1Questions =
        allQuestions.where((question) => question.importance == 1).toList();
    // 制限後
    List<Question> restrictedImportance1Questions = importance1Questions
        .where((question) => !alreadyseenQuestionIds.contains(question.id))
        .toList();
    // 重要度2
    List<Question> importance2Questions =
        allQuestions.where((question) => question.importance == 2).toList();
    // 制限後
    List<Question> restrictedImportance2Questions = importance2Questions
        .where((question) => !alreadyseenQuestionIds.contains(question.id))
        .toList();
    // 重要度3
    List<Question> importance3Questions =
        allQuestions.where((question) => question.importance == 3).toList();
    // 制限後
    List<Question> restrictedImportance3Questions = importance3Questions
        .where((question) => !alreadyseenQuestionIds.contains(question.id))
        .toList();

    // ターンを追加
    context.read(turnCountProvider).state += 1;

    // ターン数
    int turnCount = context.read(turnCountProvider).state;

    // 時間を初期化
    context.read(myTurnTimeProvider).state = 30;

    // 値を初期化
    context.read(inputAnswerProvider).state = '';
    context.read(selectQuestionIdProvider).state = 0;
    context.read(selectSkillIdsProvider).state = [];

    // 質問候補の取得
    if (restrictedImportance1Questions.length < 3 ||
        restrictedImportance2Questions.length < 3 ||
        restrictedImportance3Questions.length < 2) {
      if (importance1Questions.length < 3 ||
          importance2Questions.length < 3 ||
          importance3Questions.length < 2) {
        // 完全ランダムで取ってくる
        context.read(selectableQuestionsProvider).state =
            allQuestions.sublist(0, 3);
      } else {
        // 質問をセット
        context.read(selectableQuestionsProvider).state = getNextQuestions(
          context,
          importance1Questions,
          importance2Questions,
          importance3Questions,
          turnCount,
        );
      }
      // 取得処理
    } else {
      context.read(selectableQuestionsProvider).state = getNextQuestions(
        context,
        restrictedImportance1Questions,
        restrictedImportance2Questions,
        restrictedImportance3Questions,
        turnCount,
      );
    }

    await Future.delayed(
      const Duration(milliseconds: 800),
    );
    // ターンの開始
    soundEffect.play(
      'sounds/my_turn.mp3',
      isNotification: true,
      volume: seVolume,
    );
    context.read(myTurnFlgProvider).state = true;

    EasyLoading.showToast(
      'あなたのターンです',
      duration: const Duration(milliseconds: 1500),
      toastPosition: EasyLoadingToastPosition.center,
      dismissOnTap: true,
    );

    // 自分のターンの表示
    context.read(displayMyturnSetFlgProvider).state = true;
  } else {
    // 時間を初期化
    context.read(rivalTurnTimeProvider).state = 40;
    // 相手のターンの表示
    context.read(displayRivalturnSetFlgProvider).state = true;

    if (context.read(trainingStatusProvider).state >= 1) {
      cpuAction(
        context,
        scrollController,
        soundEffect,
        seVolume,
        false,
      );
    }
  }
}

List<Question> getNextQuestions(
  BuildContext context,
  List<Question> importance1Questions,
  List<Question> importance2Questions,
  List<Question> importance3Questions,
  int turnCount,
) {
  Question question1;
  Question question2;
  Question question3;

  final target2RandomValue = Random().nextInt(100);
  final target3RandomValue = Random().nextInt(100);

  if (turnCount < 3) {
    question1 = importance1Questions[0]; // 重要度1
    question2 = importance1Questions[1]; // 重要度1
    question3 = target3RandomValue < 90
        ? importance2Questions[0] // 90%で重要度2
        : target3RandomValue < 98
            ? importance1Questions[2] // 8%で重要度1
            : importance3Questions[0]; // 2%で重要度3
  } else if (turnCount < 5) {
    question1 = importance1Questions[0]; // 重要度1
    question2 = target2RandomValue < 60
        ? importance1Questions[1] // 60%で重要度1
        : importance2Questions[0]; // 40%で重要度2
    question3 = target3RandomValue < 87
        ? importance2Questions[1] // 87%で重要度2
        : target3RandomValue < 92
            ? importance1Questions[2] // 5%で重要度1
            : importance3Questions[0]; // 8%で重要度3
  } else if (turnCount < 7) {
    question1 = importance1Questions[0]; // 重要度1
    question2 = target2RandomValue < 90
        ? importance2Questions[0] // 90%で重要度2
        : importance1Questions[1]; // 10%で重要度1
    question3 = target3RandomValue < 88
        ? importance2Questions[1] // 88%で重要度2
        : target3RandomValue < 90
            ? importance1Questions[2] // 2%で重要度1
            : importance3Questions[0]; // 10%で重要度3
  } else if (turnCount < 9) {
    question1 = importance1Questions[0]; // 重要度1
    question2 = target2RandomValue < 90
        ? importance2Questions[0] // 90%で重要度2
        : importance1Questions[1]; // 10%で重要度1
    question3 = target3RandomValue < 90
        ? importance2Questions[1] // 80%で重要度2
        : importance3Questions[0]; // 20%で重要度3
  } else {
    question1 = importance1Questions[0]; // 重要度1
    question2 = importance2Questions[0]; // 重要度2
    question3 = target3RandomValue < 70
        ? importance3Questions[0] // 70%で重要度3
        : importance2Questions[1]; // 30%で重要度2
  }

  final setQuestions = [
    question1,
    question2,
    question3,
  ];

  setQuestions.shuffle();

  return setQuestions;
}
