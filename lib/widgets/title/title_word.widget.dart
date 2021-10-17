import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TitleWord extends HookWidget {
  const TitleWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayFlg = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 1000),
        );
        displayFlg.value = true;
      });
      return null;
    }, const []);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: displayFlg.value ? 1 : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
        ),
        child: Column(
          children: [
            Text(
              '水平思考\nモンスターズ',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1,
                fontSize: 47,
                fontFamily: 'KaiseiOpti',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.orange.shade300,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(6.0, 6.0),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Stack(
              children: <Widget>[
                Text(
                  '怪物たちの知恵比べ',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'KaiseiOpti',
                    fontSize: 23.5,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 10
                      ..color = Colors.grey.shade900,
                  ),
                ),
                Text(
                  '怪物たちの知恵比べ',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'KaiseiOpti',
                    fontSize: 23.0,
                    foreground: Paint()
                      // ..style = PaintingStyle.stroke
                      // ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
