import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CenterRowStart extends StatelessWidget {
  final bool matchingFlg;

  // ignore: use_key_in_widget_constructors
  const CenterRowStart(
    this.matchingFlg,
  );

  @override
  Widget build(BuildContext context) {
    return matchingFlg
        ? Text(
            'VS',
            style: TextStyle(
              color: Colors.red.shade200,
              fontSize: 28,
            ),
          )
        : Row(
            children: [
              SpinKitPouringHourGlassRefined(
                color: Colors.orange.shade200,
                size: 50.0,
              ),
              Text(
                'マッチング中',
                style: TextStyle(
                  color: Colors.yellow.shade200,
                  fontSize: 28,
                ),
              ),
            ],
          );
  }
}
