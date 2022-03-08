import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/providers/common.provider.dart';

void eventTimer(
  BuildContext context,
  final ValueNotifier<bool> eventUpdateState,
) async {
  Timer.periodic(
    const Duration(seconds: 1),
    (Timer timer) async {
      // 現在時刻
      final DateTime now = DateTime.now();

      if (now.hour >= 21 &&
          now.hour <= 22 &&
          !context.read(enableEventProvider).state) {
        context.read(enableEventProvider).state = true;
        eventUpdateState.value = !eventUpdateState.value;
      } else if (now.hour > 22 && context.read(enableEventProvider).state) {
        context.read(enableEventProvider).state = false;
        eventUpdateState.value = !eventUpdateState.value;
      }
    },
  );
}
