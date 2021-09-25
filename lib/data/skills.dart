import 'package:thinking_battle/models/skill.model.dart';

const skillSettings = <Skill>[
  Skill(
    id: 1,
    skillName: '質問隠し',
    skillPoint: 4,
    skillExplanation: '今回自分の行った質問が\n相手に見えなくなる（SP 4）',
  ),
  Skill(
    id: 2,
    skillName: 'ナイス質問',
    skillPoint: 4,
    skillExplanation: '正解に関係が深い質問が\n実行される（SP 4）',
  ),
  Skill(
    id: 3,
    skillName: '強制質問',
    skillPoint: 4,
    skillExplanation: '相手の次のターンのスキル使用と\n解答を封じる（SP 4）',
  ),
  Skill(
    id: 4,
    skillName: '嘘つき',
    skillPoint: 7,
    skillExplanation: '今回の自分の質問に対する嘘の返答\nが相手には表示される（SP 7）',
  ),
  Skill(
    id: 5,
    skillName: '質問調査',
    skillPoint: 8,
    skillExplanation: '相手がこれまでに「質問隠し」か\n「嘘つき」を行っていた場合、\n正しい情報を表示し直す（SP 8）',
  ),
  Skill(
    id: 6,
    skillName: 'SP溜め',
    skillPoint: 4,
    skillExplanation: '4ターンの間、質問するたびに\nSPが3溜まるようになる（SP 4）',
  ),
];
