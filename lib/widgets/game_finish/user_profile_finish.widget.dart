import 'package:flutter/material.dart';

class UserProfileFinish extends StatelessWidget {
  final MaterialColor userColor;
  final int imageNumber;
  final String userName;
  final double userRate;
  final bool myDataFlg;
  final bool? winFlg;
  final bool trainingFlg;

  // ignore: use_key_in_widget_constructors
  const UserProfileFinish(
    this.userColor,
    this.imageNumber,
    this.userName,
    this.userRate,
    this.myDataFlg,
    this.winFlg,
    this.trainingFlg,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8 > 600.0
          ? 600.0
          : MediaQuery.of(context).size.width * 0.8,
      height: 200,
      child: myDataFlg
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerIcon(
                  userColor,
                  imageNumber,
                ),
                const SizedBox(width: 30),
                _playerData(
                  userName,
                  userRate,
                  winFlg,
                  trainingFlg,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerData(
                  userName,
                  userRate,
                  winFlg == null ? null : !winFlg!,
                  trainingFlg,
                ),
                const SizedBox(width: 30),
                _playerIcon(
                  userColor,
                  imageNumber,
                ),
              ],
            ),
    );
  }

  Widget _playerIcon(
    MaterialColor playerColor,
    int imageNumber,
  ) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: playerColor,
          width: 4,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Image.asset(
          'assets/images/' + imageNumber.toString() + '.png',
        ),
      ),
    );
  }

  Widget _playerData(
    String playerName,
    double playerRate,
    bool? winFlg,
    bool trainingFlg,
  ) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
            child: Text(
              'name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            playerName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
            child: Text(
              'rate',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                playerRate.toString(),
                style: TextStyle(
                  color: trainingFlg || winFlg == null
                      ? Colors.black
                      : winFlg
                          ? Colors.blue
                          : Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 15),
              trainingFlg || winFlg == null
                  ? Container()
                  : Icon(
                      winFlg ? Icons.arrow_upward : Icons.arrow_downward,
                      color: winFlg ? Colors.blue : Colors.red,
                      size: 17,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
