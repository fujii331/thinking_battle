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
    skillName: '質問サーチ',
    skillPoint: 10,
    skillExplanation: '相手がこれまでに行った「質問隠し\n・嘘つき・トラップ」をすべて\n正しい情報で表示しなおす（SP 10）',
  ),
  Skill(
    id: 6,
    skillName: 'SP溜め',
    skillPoint: 5,
    skillExplanation: '4ターンの間、質問するたびに\nSPが3溜まるようになる（SP 5）',
  ),
  Skill(
    id: 7,
    skillName: '質問確認',
    skillPoint: 5,
    skillExplanation:
        '相手が「質問隠し・嘘つき・トラップ」\nを行っていた場合、一番新しい1つを\n正しい情報で表示しなおす（SP 5）',
  ),
  Skill(
    id: 8,
    skillName: 'トラップ',
    skillPoint: 8,
    skillExplanation: '次に相手が質問を行った際、\nその質問に対する嘘の返答が\n相手には表示される（SP 8）',
  ),
];
