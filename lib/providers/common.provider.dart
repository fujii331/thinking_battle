import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final soundEffectProvider = StateProvider((ref) => AudioCache());
final bgmProvider = StateProvider((ref) => AudioPlayer());
final bgmVolumeProvider = StateProvider((ref) => 0.2);
final seVolumeProvider = StateProvider((ref) => 0.5);
