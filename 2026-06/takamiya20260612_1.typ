#import "@preview/codelst:2.0.2": sourcecode

#set text(font: "IPAexMincho", 12pt, weight: "black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em),
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)
#show "、": ", "
#show "。": ". "
#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年   月   日  923044 髙宮 悠聖")
]

= 現在の進行状況
== リバーシAI(弱、強)
#sourcecode[```dart

  // 弱AI：合法手の中からランダムに選択
  List<int>? getWeakAiMove() {
    // 現在の手番プレイヤーの合法手一覧を取得
    List<List<int>> validMoves = _generateValidMoves(currentPlayer);

    // 合法手がなければパス
    if (validMoves.isEmpty) {
      return null;
    }

    validMoves.shuffle(); // 合法手をランダムに並び替え

    return validMoves.first; // 先頭の手を返す
  }

```]

#sourcecode[```dart
  // 強AI：盤面評価値が最も高いマスを選択
  List<int>? getStrongAiMove() {
    // 現在の合法手を取得
    List<List<int>> validMoves = _generateValidMoves(currentPlayer);

    // 合法手がなければパス
    if (validMoves.isEmpty) {
      return null;
    }

    List<int> best = validMoves.first; // とりあえず最初の手を候補にする
    int maxW = -999; // 最大評価値を保存する変数

    // 全ての合法手を調査
    for (var m in validMoves) {
      int w = _getStaticWeight(m[0], m[1]); // そのマスの静的評価値を取得

      // 現在の最大値より高ければ更新
      if (w > maxW) {
        maxW = w;
        best = m;
      }
    }

    return best; // 最も評価値の高い手を返す
  }
```]

#pagebreak()

== リバーシAI(最強)
+ Alpha-Beta枝刈り
  - 先読みをする際、負けそうな選択肢は早めに切る技術
+ NegaScout探索
  - Alpha-Beta枝刈りの改良版、一番良さそうな手以外は雑にする
+ Iterative Deepening（反復深化探索）
  - 浅い探索から徐々に深くしていく探索方法、優先順位を決めれる
+ Zobrist Hash
  - 盤面ごとに識別番号をつける、同じ盤面を考えなくていい
+ 置換表（Transposition Table）
  - Zobrist Hashとセットで使用、番号を保存
+ Move Ordering（手順序付け）
  - 強そうな手から優先的に読む
+ Killer Move
  - 大量に枝刈りした手を記憶する
+ History Heuristic
  - 過去に活躍した手の記録を行う
+ 終盤完全読み（Solver Mode）
  - 終盤になったら最後まで読み切る
+ 安定石評価
  - 絶対にひっくり返らない場所を数える
+ 可動性評価
  - 打てる場所の数を数える
+ フロンティア評価
  - 隣に空マスがある場所を数える
+ 辺パターン評価
  - 辺の形を分析
+ Static Weight
  - 角は高評価、Xマスは低評価



= 今後の予定
- 使用するプログラムの改良
