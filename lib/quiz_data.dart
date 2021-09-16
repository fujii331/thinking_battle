import 'package:thinking_battle/models/quiz.model.dart';

const quizData = [
  Quiz(
    id: 1,
    thema: '職業',
    questions: [
      Question(id: 1, asking: '特殊な服を着ている？', reply: 'はい', importance: 3),
      Question(id: 2, asking: '忙しい？', reply: 'はい', importance: 1),
      Question(id: 3, asking: '体力がいる？', reply: 'はい', importance: 2),
      Question(id: 4, asking: '背が高い人が多い？', reply: '微妙', importance: 1),
    ],
    correctAnswers: [
      'しょうぼうし',
    ],
  ),
];
