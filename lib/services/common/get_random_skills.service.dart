import 'dart:math';

List<int> getRandomSkills() {
  List<int> skills = [1, 2, 3, 4, 5, 6, 7, 8];

  final skill1Position = Random().nextInt(skills.length);
  final skill1 = skills[skill1Position];
  skills.remove(skill1);

  final skill2Position = Random().nextInt(skills.length);
  final skill2 = skills[skill2Position];
  skills.remove(skill2);

  final skill3Position = Random().nextInt(skills.length);
  final skill3 = skills[skill3Position];
  skills.remove(skill3);

  final returnSkills = [skill1, skill2, skill3];

  returnSkills.sort((a, b) => a - b);

  return returnSkills;
}
