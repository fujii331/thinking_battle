import 'package:flutter/material.dart';
import 'package:thinking_battle/screens/game_finish.screen.dart';

void navigateToGameFinish(
  BuildContext context,
  bool? winFlg,
) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        // return GameFinishScreen(winFlg);
        return GameFinishScreen();
      },
      transitionDuration: Duration(seconds: 1),
      reverseTransitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final color = ColorTween(
          begin: Colors.transparent,
          end: Colors.black, // ブラックアウト
          // end: Colors.white, // ホワイトアウト
        ).animate(CurvedAnimation(
          parent: animation,
          // 前半
          curve: const Interval(
            0.0,
            0.3,
            curve: Curves.easeInOut,
          ),
        ));
        final opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          // 後半
          curve: const Interval(
            0.3,
            1.0,
            curve: Curves.easeInOut,
          ),
        ));
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              color: color.value,
              child: Opacity(
                opacity: opacity.value,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    ),
  );
}
