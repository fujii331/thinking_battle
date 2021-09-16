class SendContent {
  final int questionId;
  final String answer;
  final List<int> skillIds;

  const SendContent({
    required this.questionId,
    required this.answer,
    required this.skillIds,
  });
}
