import 'package:hooks_riverpod/hooks_riverpod.dart';

final imageNumberProvider = StateProvider((ref) => 0);
final imageNumberListProvider = StateProvider((ref) => <String>[]);
final cardNumberProvider = StateProvider((ref) => 0);
final cardNumberListProvider = StateProvider((ref) => <String>[]);
final messageIdsListProvider = StateProvider((ref) => <String>[]);
final gpPointProvider = StateProvider((ref) => 0);
final gpCountProvider = StateProvider((ref) => 0);

final playerNameProvider = StateProvider((ref) => '');

final loginIdProvider = StateProvider((ref) => '');
// final lifePointProvider = StateProvider((ref) => 5);
// final recoveryTimeProvider = StateProvider((ref) => DateTime.now());

final rateProvider = StateProvider((ref) => 1500.0);
final maxRateProvider = StateProvider((ref) => 1500.0);
final mySkillIdsListProvider = StateProvider((ref) => <int>[1, 2, 3]);
final myMessageIdsListProvider = StateProvider((ref) => <int>[1, 2, 3, 4]);
final matchedCountProvider = StateProvider((ref) => 0);
final winCountProvider = StateProvider((ref) => 0);
final continuousWinCountProvider = StateProvider((ref) => 0);
final maxContinuousWinCountProvider = StateProvider((ref) => 0);
