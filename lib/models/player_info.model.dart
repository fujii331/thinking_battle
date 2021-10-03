class PlayerInfo {
  final String name;
  final double rate;
  final double maxRate;
  final int imageNumber;
  final int matchedCount;
  final int continuousWinCount;
  final List<int> skillList;

  const PlayerInfo({
    required this.name,
    required this.rate,
    required this.maxRate,
    required this.imageNumber,
    required this.matchedCount,
    required this.continuousWinCount,
    required this.skillList,
  });
}
