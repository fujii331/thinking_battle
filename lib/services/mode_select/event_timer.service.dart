import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/providers/common.provider.dart';

void eventTimer(
  BuildContext context,
) async {
  Timer.periodic(
    const Duration(seconds: 1),
    (Timer timer) async {
      // 現在時刻
      final DateTime now = DateTime.now();

      if (now.hour >= 20 &&
          now.hour <= 22 &&
          !context.read(enableEventProvider).state) {
        context.read(enableEventProvider).state = true;
      } else if (context.read(enableEventProvider).state) {
        context.read(enableEventProvider).state = false;
      }
    },
  );
}
