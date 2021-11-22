import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thinking_battle/widgets/game_play_content/skill_modal_content.widget.dart';

class TutorialSkillModal extends StatelessWidget {
  final List<int> selectSkillIdsList;
  final List<int> mySkillIdsList;
  final int currentSkillPoint;

  const TutorialSkillModal({
    Key? key,
    required this.selectSkillIdsList,
    required this.mySkillIdsList,
    required this.currentSkillPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Column(
          children: [
            const SizedBox(),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
              child: SkillModalContent(
                changeFlgState: ValueNotifier<bool>(false),
                soundEffect: AudioCache(),
                seVolume: 0,
                selectSkillIdsList: selectSkillIdsList,
                mySkillIdsList: mySkillIdsList,
                currentSkillPoint: currentSkillPoint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
