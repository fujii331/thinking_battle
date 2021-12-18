import 'package:flutter/material.dart';

class TutoriaCommentBox extends StatelessWidget {
  final String comment;

  const TutoriaCommentBox({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool heightOk = MediaQuery.of(context).size.height > 585;

    return Container(
      padding: const EdgeInsets.all(10),
      width: 245,
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          comment,
          style: TextStyle(
            height: 1.1,
            fontFamily: 'NotoSansJP',
            fontSize: heightOk ? 16 : 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
