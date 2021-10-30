import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';

final quizThemaProvider = StateProvider((ref) => '');
final correctAnswersProvider = StateProvider((ref) => <String>[]);
final allQuestionsProvider = StateProvider((ref) => <Question>[]);
final displayContentListProvider = StateProvider((ref) => <DisplayContent>[]);
final turnCountProvider = StateProvider((ref) => 0);
final trainingProvider = StateProvider((ref) => false);
final changedTrainingProvider = StateProvider((ref) => false);
final friendMatchWordProvider = StateProvider((ref) => '');
final rivalInfoProvider = StateProvider((ref) => dummyPlayerInfo);
final matchingWaitingIdProvider = StateProvider((ref) => '');
final matchingRoomIdProvider = StateProvider((ref) => '');
final precedingFlgProvider = StateProvider((ref) => false);

const dummyPlayerInfo = PlayerInfo(
  name: '',
  rate: 0,
  imageNumber: 0,
  cardNumber: 0,
  matchedCount: 0,
  continuousWinCount: 0,
  skillList: [],
);

final alreadyseenQuestionsProvider = StateProvider((ref) => <Question>[]);

final myTurnTimeProvider = StateProvider((ref) => 30);
final rivalTurnTimeProvider = StateProvider((ref) => 45);

final myTurnFlgProvider = StateProvider((ref) => false);
final currentSkillPointProvider = StateProvider((ref) => 5);
final enemySkillPointProvider = StateProvider((ref) => 5);

final inputAnswerProvider = StateProvider((ref) => '');
final selectableQuestionsProvider = StateProvider((ref) => <Question>[]);
final selectQuestionIdProvider = StateProvider((ref) => 0);
final selectSkillIdsProvider = StateProvider((ref) => <int>[]);
final selectMessageIdProvider = StateProvider((ref) => 0);
final afterMessageTimeProvider = StateProvider((ref) => 0);

final answerFailedFlgProvider = StateProvider((ref) => false);
final forceQuestionFlgProvider = StateProvider((ref) => false);
final displayMyturnSetFlgProvider = StateProvider((ref) => false);
final displayRivalturnSetFlgProvider = StateProvider((ref) => false);

final displayQuestionResearchProvider = StateProvider((ref) => 0);
final animationQuestionResearchProvider = StateProvider((ref) => false);
final spChargeTurnProvider = StateProvider((ref) => 0);
final myTrapCountProvider = StateProvider((ref) => 0);
final enemyTrapCountProvider = StateProvider((ref) => 0);
final skillUseCountInGameProvider = StateProvider((ref) => 0);
