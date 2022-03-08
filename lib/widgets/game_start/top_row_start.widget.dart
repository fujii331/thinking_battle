import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TopRowStart extends StatelessWidget {
  final bool matchingFlg;

  const TopRowStart({
    Key? key,
    required this.matchingFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Center(
        child: matchingFlg
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '準備完了！!',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'MochiyPopOne',
                    color: Colors.orange.shade200,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPouringHourGlassRefined(
                    color: Colors.orange.shade200,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '待機中...',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'MochiyPopOne',
                      color: Colors.yellow.shade100,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
