import 'package:flutter/material.dart';

MaterialColor returnColor(
  double rate,
) {
  return rate >= 2500
      ? Colors.purple
      : rate >= 2250
          ? Colors.red
          : rate >= 2000
              ? Colors.orange
              : rate >= 1750
                  ? Colors.green
                  : Colors.blue;
}
