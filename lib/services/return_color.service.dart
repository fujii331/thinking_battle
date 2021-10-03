import 'package:flutter/material.dart';

// ボックスの中身
// 名前
// border
// スキル
List returnColor(
  double rate,
) {
  return rate < 1750
      ? [
          [
            Colors.deepPurple.shade900,
            Colors.blue.shade900,
            Colors.indigo.shade900,
          ],
          [
            Colors.blue.shade900,
            Colors.indigo.shade500,
          ],
          Colors.indigo.shade800,
          Colors.lightBlue.shade800,
        ]
      : rate < 2000
          ? [
              [
                Colors.teal.shade900,
                Colors.lightGreen.shade900,
                Colors.green.shade900,
              ],
              [
                Colors.teal.shade800,
                Colors.lightGreen.shade800,
              ],
              Colors.green.shade800,
              Colors.green.shade700
            ]
          : rate < 2250
              ? [
                  [
                    Colors.deepOrange.shade900,
                    Colors.deepOrange.shade700,
                    Colors.deepOrange.shade900,
                  ],
                  [
                    Colors.deepOrange.shade800,
                    Colors.orange.shade700,
                  ],
                  Colors.orange.shade800,
                  Colors.amber.shade800
                ]
              : rate < 2500
                  ? [
                      [
                        Colors.pink.shade900,
                        Colors.red.shade900,
                        Colors.pink.shade900,
                      ],
                      [
                        Colors.red.shade900,
                        Colors.pink.shade700,
                      ],
                      Colors.pink.shade700,
                      const Color.fromRGBO(245, 150, 77, 0.6)
                    ]
                  : rate < 2750
                      ? [
                          [
                            Colors.deepPurple.shade900,
                            Colors.purple.shade800,
                            Colors.indigo.shade900,
                          ],
                          [
                            Colors.purple.shade800,
                            Colors.deepPurple.shade500,
                          ],
                          Colors.purple.shade700,
                          Colors.purple.shade600,
                        ]
                      : rate < 3000
                          ? [
                              [
                                Colors.grey.shade900,
                                Colors.blueGrey.shade700,
                                Colors.blueGrey.shade800,
                              ],
                              [
                                Colors.blueGrey.shade800,
                                Colors.grey.shade700,
                              ],
                              Colors.blueGrey.shade600,
                              Colors.grey.shade600,
                            ]
                          : [
                              [
                                Colors.black,
                                Colors.grey.shade900,
                                Colors.black,
                              ],
                              [
                                Colors.grey.shade900,
                                Colors.grey.shade800,
                              ],
                              Colors.grey.shade800,
                              Colors.grey.shade800
                            ];
}
