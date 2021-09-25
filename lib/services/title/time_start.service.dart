// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:intl/intl.dart';

// import 'package:thinking_battle/providers/game.provider.dart';

// // ライフ設定用
// void timeStart(
//   BuildContext context,
// ) {
//   Timer.periodic(
//     const Duration(seconds: 1),
//     (Timer timer) async {
//       if (context.read(lifePointProvider).state < 5) {
//         final updatedRecoveryTime =
//             context.read(recoveryTimeProvider).state.add(
//                   const Duration(
//                     seconds: -1,
//                   ),
//                 );
//         context.read(recoveryTimeProvider).state = updatedRecoveryTime;

//         if (DateFormat('mm:ss').format(updatedRecoveryTime) == '00:00') {
//           context.read(lifePointProvider).state += 1;
//           context.read(recoveryTimeProvider).state =
//               DateTime(2020, 1, 1, 1, 15);
//         }
//       }

//       if (timer.isActive && context.read(timerCancelFlgProvider).state) {
//         timer.cancel();
//       }
//     },
//   );
// }
