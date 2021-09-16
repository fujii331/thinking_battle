import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';

final imageNumberProvider = StateProvider((ref) => 0);
final playerNameProvider = StateProvider((ref) => '');
final lifePointProvider = StateProvider((ref) => 5);
final recoveryTimeProvider = StateProvider((ref) => DateTime.now());
final timerCancelFlgProvider = StateProvider((ref) => false);

final correctAnswersProvider = StateProvider((ref) => <String>[]);
final allQuestionsProvider = StateProvider((ref) => <Question>[]);
final displayContentListProvider = StateProvider((ref) => <DisplayContent>[]);
final turnCountProvider = StateProvider((ref) => 0);
final trainingProvider = StateProvider((ref) => false);
final sumImportanceProvider = StateProvider((ref) => 0);
final rivalInfoProvider = StateProvider((ref) => dummyPlayerInfo);
final rivalColorProvider = StateProvider((ref) => Colors.blue);

const dummyPlayerInfo =
    PlayerInfo(name: '', rate: 0, maxRate: 0, imageNumber: 0, skillList: []);

final alreadyseenQuestionsProvider = StateProvider((ref) => <Question>[]);

final myTurnTimeProvider = StateProvider((ref) => DateTime.now());
final myTurnFlgProvider = StateProvider((ref) => false);
final currentSkillPointProvider = StateProvider((ref) => 3);
final enemySkillPointProvider = StateProvider((ref) => 3);
final enemySkillsProvider = StateProvider((ref) => <int>[]);

final inputAnswerProvider = StateProvider((ref) => '');
final selectableQuestionsProvider = StateProvider((ref) => <Question>[]);
final selectQuestionIdProvider = StateProvider((ref) => 0);
final selectSkillIdsProvider = StateProvider((ref) => <int>[]);

final answerFailedFlgProvider = StateProvider((ref) => false);
final forceQuestionFlgProvider = StateProvider((ref) => false);
final displayMyturnSetFlgProvider = StateProvider((ref) => false);
final displayRivalturnSetFlgProvider = StateProvider((ref) => false);

final displayQuestionResearchProvider = StateProvider((ref) => false);
final animationQuestionResearchProvider = StateProvider((ref) => false);
final spChargeTurnProvider = StateProvider((ref) => 0);

final rateProvider = StateProvider((ref) => 500.0);
final maxRateProvider = StateProvider((ref) => 500.0);
final colorProvider = StateProvider((ref) => Colors.blue);
final mySkillIdsListProvider = StateProvider((ref) => <int>[1, 2, 3]);
