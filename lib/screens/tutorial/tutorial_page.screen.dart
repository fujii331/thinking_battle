import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';

class TutorialPageScreen extends HookWidget {
  const TutorialPageScreen({Key? key}) : super(key: key);
  static const routeName = '/tutorial-page';

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final String title = args[0] as String;
    final List<Widget> childrenWidget = args[1] as List<Widget>;
    final PageController pageController =
        usePageController(initialPage: 0, keepPage: true);

    final ValueNotifier<double> notifier = useState(0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900.withOpacity(0.9),
      ),
      body: Stack(
        children: <Widget>[
          background(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    notifier.value = index.toDouble();
                  },
                  children: childrenWidget,
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade800,
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: SlidingIndicator(
                      indicatorCount: childrenWidget.length,
                      notifier: notifier,
                      activeIndicator: const Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      inActiveIndicator: Icon(
                        Icons.circle,
                        color: Colors.grey.shade400,
                      ),
                      margin: 8,
                      inactiveIndicatorSize: 12,
                      activeIndicatorSize: 14,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.white.withOpacity(0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: notifier.value != 0
                                ? const Text(
                                    '←',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 15),
                            child: notifier.value != childrenWidget.length - 1
                                ? const Text(
                                    '→',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Platform.isAndroid ? 0 : 30),
            ],
          ),
        ],
      ),
    );
  }
}
