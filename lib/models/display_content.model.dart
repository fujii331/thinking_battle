class DisplayContent {
  final String content;
  final String reply;
  final bool answerFlg;
  final bool myTurnFlg;
  final List<int> skillIds;
  final List displayList;
  final int importance;
  final String specialMessage;

  const DisplayContent({
    required this.content,
    required this.reply,
    required this.answerFlg,
    required this.myTurnFlg,
    required this.skillIds,
    required this.displayList,
    required this.importance,
    required this.specialMessage,
  });
}
