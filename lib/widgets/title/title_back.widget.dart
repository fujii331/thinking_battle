import 'package:flutter/material.dart';

class TitleBack extends StatelessWidget {
  const TitleBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/common_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background/title_back_monster.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
