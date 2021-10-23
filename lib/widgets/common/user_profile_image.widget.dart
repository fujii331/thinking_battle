import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final int imageNumber;
  final List colorList;

  const UserProfileImage({
    Key? key,
    required this.imageNumber,
    required this.colorList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25),
      child: Container(
        padding: const EdgeInsets.all(6),
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: colorList[0][0],
            stops: const [
              0.2,
              0.6,
              0.9,
            ],
          ),
          border: Border.all(
            color: colorList[0][1],
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: imageNumber == 0
            ? Container()
            : Image.asset(
                'assets/images/characters/' + imageNumber.toString() + '.png',
              ),
      ),
    );
  }
}
