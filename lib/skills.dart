import 'package:thinking_battle/models/skill.model.dart';

const skillSettings = <Skill>[
  Skill(
    id: 1,
    skillName: '質問隠し',
    skillPoint: 5,
    skillExplanation: '今回自分の行った質問が相手に見えなくなる（SP:5）',
  ),
  Skill(
    id: 2,
    skillName: 'ナイス質問',
    skillPoint: 3,
    skillExplanation: '正解に関係が深い質問が実行される（SP:3）',
  ),
  Skill(
    id: 3,
    skillName: '強制質問',
    skillPoint: 4,
    skillExplanation: '相手の次のターンのスキル使用と解答を封じる（SP:4）',
  ),
  Skill(
    id: 4,
    skillName: '嘘つき',
    skillPoint: 7,
    skillExplanation:
        '今回の自分の質問に対する解答が「はい」の時は「いいえ」が、「微妙、いいえ」の時は「はい」が相手には表示される（SP:7）',
  ),
  Skill(
    id: 5,
    skillName: '質問調査',
    skillPoint: 10,
    skillExplanation: '相手がこれまでに「質問隠し」か「嘘つき」を行っていた場合、正しい情報を表示し直す（SP:10）',
  ),
  Skill(
    id: 6,
    skillName: 'SP溜め',
    skillPoint: 5,
    skillExplanation: '次から3ターンの間、質問するたびにSPが4溜まるようになる（SP:5）',
  ),
];
