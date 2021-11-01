import 'package:flutter/material.dart';

List returnCardColorList(
  int cardNumber,
) {
  List<int> darkColorList = [
    5,
    8,
    10,
    13,
    16,
    17,
    19,
    20,
    1002,
    1003,
    1004,
    1006,
    1007,
  ];
  List colorList = cardNumber < 8
      ? (cardNumber == 1
          ? [
              [
                Colors.lightBlue.shade100,
                Colors.blue.shade100,
                Colors.indigo.shade100,
              ],
              Colors.blue.shade700
            ]
          : cardNumber == 2
              ? [
                  [
                    Colors.pink.shade100,
                    Colors.red.shade50,
                    Colors.pink.shade50,
                  ],
                  Colors.pink.shade200
                ]
              : cardNumber == 3
                  ? [
                      [
                        Colors.orange.shade100,
                        Colors.yellow.shade100,
                        Colors.lime.shade100,
                      ],
                      Colors.orange.shade600
                    ]
                  : cardNumber == 4
                      ? [
                          [
                            Colors.yellow.shade50,
                            Colors.blueGrey.shade50,
                            Colors.brown.shade100,
                          ],
                          Colors.brown.shade200
                        ]
                      : cardNumber == 5
                          ? [
                              [
                                Colors.blue.shade700,
                                Colors.indigo.shade700,
                                Colors.indigo.shade800,
                              ],
                              Colors.indigo.shade900
                            ]
                          : cardNumber == 6
                              ? [
                                  [
                                    Colors.orange.shade200,
                                    Colors.orange.shade50,
                                    Colors.grey.shade50,
                                  ],
                                  Colors.orange.shade300
                                ]
                              : [
                                  [
                                    Colors.brown.shade100,
                                    Colors.orange.shade50,
                                    Colors.grey.shade100,
                                  ],
                                  Colors.brown.shade200
                                ])
      : cardNumber < 16
          ? (cardNumber == 8
              ? [
                  [
                    Colors.grey.shade900,
                    Colors.deepPurple.shade900,
                    Colors.blueGrey.shade800,
                  ],
                  Colors.amber.shade600
                ]
              : cardNumber == 9
                  ? [
                      [
                        Colors.cyan.shade100,
                        Colors.blue.shade50,
                        Colors.lightBlue.shade200,
                      ],
                      Colors.cyan.shade600
                    ]
                  : cardNumber == 10
                      ? [
                          [
                            Colors.brown.shade800,
                            Colors.red.shade900,
                            Colors.brown.shade900,
                          ],
                          Colors.brown.shade600
                        ]
                      : cardNumber == 11
                          ? [
                              [
                                Colors.amber.shade200,
                                Colors.yellow.shade100,
                                Colors.brown.shade50,
                              ],
                              Colors.brown.shade300
                            ]
                          : cardNumber == 12
                              ? [
                                  [
                                    Colors.pink.shade100,
                                    Colors.yellow.shade100,
                                    Colors.pink.shade100,
                                  ],
                                  Colors.brown.shade300
                                ]
                              : cardNumber == 13
                                  ? [
                                      [
                                        Colors.purple.shade300,
                                        Colors.deepPurple.shade500,
                                        Colors.purple.shade400,
                                      ],
                                      Colors.orange.shade500
                                    ]
                                  : cardNumber == 14
                                      ? [
                                          [
                                            Colors.pink.shade50,
                                            Colors.red.shade50,
                                            Colors.pink.shade100,
                                          ],
                                          Colors.pink.shade200
                                        ]
                                      : [
                                          [
                                            Colors.blue.shade100,
                                            Colors.pink.shade50,
                                            Colors.pink.shade100,
                                          ],
                                          Colors.blue.shade200
                                        ])
          : cardNumber < 24
              ? cardNumber == 16
                  ? [
                      [
                        Colors.purple.shade400,
                        Colors.deepPurple.shade300,
                        Colors.purple.shade300,
                      ],
                      Colors.pink.shade100
                    ]
                  : cardNumber == 17
                      ? [
                          [
                            Colors.black,
                            Colors.grey.shade900,
                            Colors.black,
                          ],
                          Colors.pink.shade300
                        ]
                      : cardNumber == 18
                          ? [
                              [
                                Colors.grey.shade200,
                                Colors.blueGrey.shade50,
                                Colors.grey.shade400,
                              ],
                              Colors.blueGrey.shade300
                            ]
                          : cardNumber == 19
                              ? [
                                  [
                                    Colors.indigo.shade900,
                                    Colors.grey.shade900,
                                    Colors.deepPurple.shade900,
                                  ],
                                  Colors.yellow.shade600
                                ]
                              : cardNumber == 20
                                  ? [
                                      [
                                        Colors.grey.shade800,
                                        Colors.blueGrey.shade900,
                                        Colors.grey.shade900,
                                      ],
                                      Colors.amber.shade500
                                    ]
                                  : [
                                      [
                                        Colors.white,
                                        Colors.grey.shade100,
                                        Colors.white,
                                      ],
                                      Colors.grey.shade300
                                    ]
              : cardNumber == 1001
                  ? [
                      [
                        Colors.yellow.shade200,
                        Colors.cyan.shade100,
                        Colors.red.shade100,
                      ],
                      Colors.purple.shade300
                    ]
                  : cardNumber == 1002
                      ? [
                          [
                            Colors.black,
                            Colors.purple.shade900,
                            Colors.blue.shade900,
                          ],
                          Colors.deepPurple.shade900
                        ]
                      : cardNumber == 1003
                          ? [
                              [
                                Colors.lightBlue.shade700,
                                Colors.purple.shade800,
                                Colors.pink.shade700,
                              ],
                              Colors.purple.shade800
                            ]
                          : cardNumber == 1004
                              ? [
                                  [
                                    Colors.black,
                                    Colors.indigo.shade900,
                                    Colors.black,
                                  ],
                                  Colors.indigo.shade800
                                ]
                              : cardNumber == 1005
                                  ? [
                                      [
                                        Colors.orange.shade300,
                                        Colors.orange.shade100,
                                        Colors.yellow.shade200,
                                      ],
                                      Colors.amber.shade700
                                    ]
                                  : cardNumber == 1006
                                      ? [
                                          [
                                            Colors.grey.shade900,
                                            Colors.black,
                                            Colors.grey.shade900,
                                          ],
                                          Colors.green.shade500
                                        ]
                                      : [
                                          [
                                            Colors.purple.shade900,
                                            Colors.deepPurple.shade900,
                                            Colors.red.shade900,
                                          ],
                                          Colors.pink.shade900
                                        ];
  return [colorList, darkColorList.contains(cardNumber)];
}
