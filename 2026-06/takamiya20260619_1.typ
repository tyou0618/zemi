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
== コード改良場所の確認
- しばらく触ってなかったので中身と作動方法の確認を行なった
- 今後変更するにあたって改良できる場所と改良の方法を確認した


= 今後の予定
== コードの変更
+ 学習の周回数（エポック数）の調整
  - 何を変更できるか: AIに同じデータを何回繰り返して学習させるか（学習の長さ）
  - 変更ファイル: train.py
  - ファイルの具体的な変更場所: 冒頭の main() 関数内、コマンドライン引数を設定している parser.add_argument('--num_epochs', ...) の行

+ 学習の更新歩幅（学習率）の調整
  - 何を変更できるか: パラメータを更新する際の「一歩の大きさ」。小さすぎると学習が終わらず、大きすぎると計算が破綻（NaN）する
  - 変更ファイル: train.py
  - ファイルの具体的な変更場所: 冒頭の引数設定部分にある parser.add_argument('--learning_rate', ...) の行。

+ ミニバッチサイズ（一度に処理するデータ数）の調整
  - 何を変更できるか: 1回の計算で同時に処理する時系列シーケンスの数。Mac miniのメモリ負担と学習の安定性に直結します。
  - 変更ファイル: train.py
  - ファイルの具体的な変更場所: 冒頭の引数設定部分にある parser.add_argument('--batch_size', ...) の行。
  - 変更ファイル: utils.py
  - ファイルの具体的な変更場所: DataLoader.__init__ 関数内にある、学習用データのパスを格納したリスト base_train_dataset = [...] の中身。

+ 最適化アルゴリズム（オプティマイザ）の切り替え
  - 何を変更できるか: AIの重み（パラメータ）を更新する内部アルゴリズムの仕組み。現在最も標準的で強力な Adam などに変更して精度向上を狙います。
  - 変更ファイル: train.py
  - ファイルの具体的な変更場所: 中盤のオプティマイザのインスタンスを生成している箇所（optimizer = ...）。
