import 'package:cloud_firestore/cloud_firestore.dart';

class SendContent {
  final int questionId;
  final String answer;
  final List<int> skillIds;
  final int messageId;

  const SendContent({
    required this.questionId,
    required this.answer,
    required this.skillIds,
    required this.messageId,
  });

  factory SendContent.fromJson(DocumentSnapshot<Object?> json) {
    final skillIds = json['skillIds'] as List;
    return SendContent(
      questionId: json['questionId'] as int,
      answer: json['answer'] as String,
      skillIds: skillIds.isEmpty
          ? []
          : skillIds.length == 1
              ? [skillIds[0] as int]
              : skillIds.length == 2
                  ? [
                      skillIds[0] as int,
                      skillIds[1] as int,
                    ]
                  : [
                      skillIds[0] as int,
                      skillIds[1] as int,
                      skillIds[2] as int,
                    ],
      messageId: json['messageId'] as int,
    );
  }
}
