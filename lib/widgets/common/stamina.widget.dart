// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:intl/intl.dart';

// import 'package:thinking_battle/providers/common.provider.dart';
// import 'package:thinking_battle/providers/game.provider.dart';

// class Stamina extends HookWidget {
//   const Stamina({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final AudioCache soundEffect = useProvider(soundEffectProvider).state;
//     final double seVolume = useProvider(seVolumeProvider).state;
//     final int lifePoint = useProvider(lifePointProvider).state;
//     final DateTime recoveryTime = useProvider(recoveryTimeProvider).state;

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         vertical: 7,
//         horizontal: 10,
//       ),
//       height: 50,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: FractionalOffset.topLeft,
//           end: FractionalOffset.bottomRight,
//           colors: [
//             Colors.blueGrey.shade900,
//             Colors.blueGrey.shade600,
//             Colors.blueGrey.shade800,
//           ],
//           stops: const [
//             0.2,
//             0.6,
//             0.9,
//           ],
//         ),
//         border: Border.all(
//           color: Colors.indigo.shade800,
//           width: 3,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'スタミナ',
//             style: TextStyle(
//               height: 1.2,
//               fontSize: 18,
//               fontFamily: 'KaiseiOpti',
//               fontWeight: FontWeight.bold,
//               color: Colors.orange.shade200,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Icon(
//             lifePoint > 0 ? Icons.savings : Icons.savings_outlined,
//             color: Colors.yellow,
//             size: 17,
//           ),
//           const SizedBox(width: 3),
//           Icon(
//             lifePoint > 1 ? Icons.savings : Icons.savings_outlined,
//             color: Colors.yellow,
//             size: 17,
//           ),
//           const SizedBox(width: 3),
//           Icon(
//             lifePoint > 2 ? Icons.savings : Icons.savings_outlined,
//             color: Colors.yellow,
//             size: 17,
//           ),
//           const SizedBox(width: 3),
//           Icon(
//             lifePoint > 3 ? Icons.savings : Icons.savings_outlined,
//             color: Colors.yellow,
//             size: 17,
//           ),
//           const SizedBox(width: 3),
//           Icon(
//             lifePoint > 4 ? Icons.savings : Icons.savings_outlined,
//             color: Colors.yellow,
//             size: 17,
//           ),
//           Container(
//             padding: const EdgeInsets.only(
//               left: 15,
//             ),
//             width: 70,
//             child: Text(
//               lifePoint < 5 ? DateFormat('mm:ss').format(recoveryTime) : 'MAX',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//               ),
//             ),
//           ),
//           IconButton(
//             padding: const EdgeInsets.all(0), // デフォルトを上書き
//             icon: Icon(
//               Icons.local_florist_rounded,
//               color: lifePoint < 5 ? Colors.pink.shade300 : Colors.grey,
//               size: 20,
//             ),
//             onPressed: lifePoint == 5
//                 ? () {}
//                 : () {
//                     soundEffect.play(
//                       'sounds/tap.mp3',
//                       isNotification: true,
//                       volume: seVolume,
//                     );
//                     // 動画を見せて回復
//                   },
//           ),
//         ],
//       ),
//     );
//   }
// }
