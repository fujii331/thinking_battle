class PlayerInfo {
  final String name;
  final double rate;
  final int imageNumber;
  final int cardNumber;
  final int matchedCount;
  final int continuousWinCount;
  final List<int> skillList;

  const PlayerInfo({
    required this.name,
    required this.rate,
    required this.imageNumber,
    required this.cardNumber,
    required this.matchedCount,
    required this.continuousWinCount,
    required this.skillList,
  });
}
