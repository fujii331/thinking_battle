import 'package:flutter/material.dart';
import 'package:thinking_battle/services/return_color.service.dart';

class UserProfileFinish extends StatelessWidget {
  final int imageNumber;
  final int matchedCount;
  final int continuousWinCount;
  final String userName;
  final double userRate;
  final double maxRate;
  final bool myDataFlg;
  final bool? winFlg;
  final bool trainingFlg;

  // ignore: use_key_in_widget_constructors
  const UserProfileFinish(
    this.imageNumber,
    this.matchedCount,
    this.continuousWinCount,
    this.userName,
    this.userRate,
    this.maxRate,
    this.myDataFlg,
    this.winFlg,
    this.trainingFlg,
  );

  @override
  Widget build(BuildContext context) {
    final List colorSet = returnColor(maxRate);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 5,
            top: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: colorSet[0],
              stops: const [
                0.2,
                0.6,
                0.9,
              ],
            ),
            border: Border.all(
              color: colorSet[2],
              width: 3,
            ),
          ),
          width: 235,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _playerIcon(
                imageNumber,
              ),
              const SizedBox(width: 45),
              _playerData(
                userRate,
                matchedCount,
                winFlg,
                trainingFlg,
                myDataFlg,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 13,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            height: 32,
            width: 125,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                colors: colorSet[1],
                stops: const [
                  0.6,
                  0.9,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                SizedBox(
                  height: 9,
                  child: Text(
                    'name',
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'KaiseiOpti',
                    fontSize: 13.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        continuousWinCount > 1
            ? Padding(
                padding: const EdgeInsets.only(left: 60.0, top: 5),
                child: Text(
                  continuousWinCount.toString() + ' 連勝中！',
                  style: TextStyle(
                    color: Colors.yellow.shade100,
                    fontFamily: 'KaiseiOpti',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _playerIcon(
    int imageNumber,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(
            color: Colors.grey.shade800,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: imageNumber == 0
              ? Container()
              : Image.asset(
                  'assets/images/' + imageNumber.toString() + '.png',
                ),
        ),
      ),
    );
  }

  Widget _playerData(
    double playerRate,
    int matchedCount,
    bool? winFlg,
    bool trainingFlg,
    bool myDataFlg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
          child: Text(
            'match',
            style: TextStyle(
              color: Colors.blueGrey.shade200,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          (matchedCount + (!trainingFlg && !myDataFlg ? 1 : 0)).toString() +
              ' 回',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'KaiseiOpti',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 15,
          child: Text(
            'rate',
            style: TextStyle(
              color: Colors.blueGrey.shade200,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(
          width: 82,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                playerRate.toString(),
                style: TextStyle(
                  color: trainingFlg || winFlg == null
                      ? Colors.white
                      : winFlg
                          ? Colors.blue.shade200
                          : Colors.red.shade200,
                  fontSize: 18,
                  fontFamily: 'KaiseiOpti',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              trainingFlg || winFlg == null
                  ? Container()
                  : Icon(
                      winFlg ? Icons.arrow_upward : Icons.arrow_downward,
                      color:
                          winFlg ? Colors.blue.shade200 : Colors.red.shade200,
                      size: 17,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
