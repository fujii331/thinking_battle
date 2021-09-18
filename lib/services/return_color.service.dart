import 'package:flutter/material.dart';

MaterialColor returnColor(
  double rate,
) {
  return rate >= 1500
      ? Colors.purple
      : rate >= 1250
          ? Colors.red
          : rate >= 1000
              ? Colors.orange
              : rate >= 750
                  ? Colors.green
                  : Colors.blue;
}
