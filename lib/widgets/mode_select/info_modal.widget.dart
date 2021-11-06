// import 'package:app_review/app_review.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share/share.dart';
import 'package:thinking_battle/data/info_contents.dart';
import 'package:thinking_battle/models/info.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/widgets/common/comment_modal.widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InfoModal extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final List<String> watchedInfoList;

  const InfoModal({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.watchedInfoList,
  }) : super(key: key);

  void openInfoModal(
    AudioCache soundEffect,
    double seVolume,
    BuildContext context,
    Info infoContent,
    bool notWatchedInfoFlg,
    ValueNotifier<bool> changeFlgState,
  ) async {
    soundEffect.play(
      'sounds/tap.mp3',
      isNotification: true,
      volume: seVolume,
    );
    if (notWatchedInfoFlg) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      watchedInfoList.add(infoContent.id.toString());
      context.read(watchedInfoListProvider).state = watchedInfoList;
      prefs.setStringList('watchedInfoList', watchedInfoList);
      changeFlgState.value = !changeFlgState.value;
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      showCloseIcon: true,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: CommentModal(
        topText: infoContent.title,
        secondText: infoContent.content,
        closeButtonFlg: false,
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> changeFlgState = useState(false);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        children: [
          const Text(
            'インフォメーション',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width * .86 > 550
                ? 450
                : MediaQuery.of(context).size.width * .62,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final Info infoContent =
                    infoContents[infoContents.length - 1 - index];

                final bool notWatchedInfoFlg = !context
                    .read(watchedInfoListProvider)
                    .state
                    .contains(infoContent.id.toString());

                return Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () => openInfoModal(
                          soundEffect,
                          seVolume,
                          context,
                          infoContent,
                          notWatchedInfoFlg,
                          changeFlgState,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 10,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 1.0,
                                offset: const Offset(3, 3),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                infoContent.dateString,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                infoContent.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'KaiseiOpti',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        // color: Colors.blue,
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Spacer(),
                            InkWell(
                              onTap: () => openInfoModal(
                                soundEffect,
                                seVolume,
                                context,
                                infoContent,
                                notWatchedInfoFlg,
                                changeFlgState,
                              ),
                              child: Icon(
                                Icons.circle,
                                color: notWatchedInfoFlg
                                    ? Colors.red
                                    : Colors.red.withOpacity(0),
                                size: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: infoContents.length,
            ),
          ),
          // リリース後
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     const SizedBox(),
          //     const Spacer(),
          //     IconButton(
          //       iconSize: 25,
          //       icon: Icon(
          //         Icons.share,
          //         color: Colors.blue.shade700,
          //       ),
          //       onPressed: () {
          //         Share.share(
          //             '水平思考モンスターズをやってみませんか？\n相手の裏をかいて閃く爽快感が味わえる！\n\nhttps://example.com');
          //       },
          //     ),
          //     IconButton(
          //       iconSize: 25,
          //       icon: Icon(
          //         Icons.rate_review,
          //         color: Colors.green.shade700,
          //       ),
          //       onPressed: () {
          //         // AppReview.requestReview.then(
          //         //   (_) {},
          //         // );
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
