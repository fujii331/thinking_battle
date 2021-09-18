import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/widgets/common/update_version_modal.widget.dart';

Future shouldUpdate(
  BuildContext context,
) async {
  await Firebase.initializeApp();
  const String configName = "force_update_build_number";

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  int currentVersion = int.parse(packageInfo.buildNumber);

  // remoteConfigの初期化
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(seconds: 0),
  ));
  await remoteConfig.setDefaults(<String, dynamic>{
    configName: currentVersion,
  });
  await remoteConfig.fetchAndActivate();

  int newVersion = remoteConfig.getInt(configName);

  if (newVersion > currentVersion) {
    context.read(soundEffectProvider).state.play(
          'sounds/hint.mp3',
          isNotification: true,
          volume: context.read(seVolumeProvider).state,
        );
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO_REVERSED,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: const UpdateVersionModal(),
    ).show();
  }
  ;
}
