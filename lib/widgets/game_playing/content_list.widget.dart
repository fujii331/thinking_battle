import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_play_content/content_list_content.widget.dart';

class ContentList extends HookWidget {
  final ScrollController scrollController;
  final PlayerInfo rivalInfo;
  final List rivalColorList;

  const ContentList({
    Key? key,
    required this.scrollController,
    required this.rivalInfo,
    required this.rivalColorList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DisplayContent> displayContentList =
        useProvider(displayContentListProvider).state;
    final int displayQuestionResearch =
        useProvider(displayQuestionResearchProvider).state;
    final bool animationQuestionResearch =
        useProvider(animationQuestionResearchProvider).state;

    return ContentListContent(
        scrollController: scrollController,
        rivalInfo: rivalInfo,
        displayContentList: displayContentList,
        displayQuestionResearch: displayQuestionResearch,
        animationQuestionResearch: animationQuestionResearch,
        rivalColorList: rivalColorList,
        contentHeight: MediaQuery.of(context).size.height - 250);
  }
}
