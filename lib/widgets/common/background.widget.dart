import 'package:flutter/material.dart';

Widget background() {
  return Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/title_back.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Opacity(
        opacity: 0.2,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  );
}
