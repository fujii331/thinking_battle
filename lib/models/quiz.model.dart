class Question {
  final int id;
  final String asking;
  final String reply;
  final int importance;

  const Question({
    required this.id,
    required this.asking,
    required this.reply,
    required this.importance,
  });
}

class Quiz {
  final int id;
  final String thema;
  final List<Question> questions;
  final List<String> correctAnswers;
  final List<String> wrongAnswers;
  final List<String> answerCandidate;

  const Quiz({
    required this.id,
    required this.thema,
    required this.questions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.answerCandidate,
  });
}
