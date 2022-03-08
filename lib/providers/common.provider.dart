import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/eventData.model.dart';

final soundEffectProvider = StateProvider((ref) => AudioCache());
final bgmProvider = StateProvider((ref) => AudioPlayer());
final bgmVolumeProvider = StateProvider((ref) => 0.2);
final seVolumeProvider = StateProvider((ref) => 0.5);
final timerCancelFlgProvider = StateProvider((ref) => false);
final buildNumberProvider = StateProvider((ref) => 0);
final watchedInfoListProvider = StateProvider((ref) => <String>[]);

final backgroundProvider = StateProvider((ref) => false);

// イベント関連
final enableEventProvider = StateProvider((ref) => false);
final eventTopListProvider = StateProvider((ref) => <EventData>[]);
final eventRoundMeListProvider = StateProvider((ref) => <EventData>[]);
final eventPlayersCountProvider = StateProvider((ref) => 0);
