#set text(font: "IPAexMincho", 12pt, weight: "black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em),
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)

#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年   月   日  923044 髙宮 悠聖")
]

= 現在の進行状況
== Social-LSTM
#align()[
  #image("takamiya20260522p2.png", width: 30%)
]
=== 今後特に使用するプログラム
- model.py
Social-LSTM本体で、LSTMやSocial Pooling、未来予測を行なっている.\
現在は過去の軌跡をもとに未来予測を行なっているため、ここに心理バイアスによる推測モデルを追加する.

- utils.py
データ処理を行なっており、今後心理バイアスを特徴量に変換する処理を追加する.

- grid.py
Social Poolingを実装し、近くの人をどのように扱うかを決定している.

- visualize.py
予測結果を見るためのプログラム.

- train.py
学習を実行するためのプログラム.

#pagebreak()

=== フォルダの役割
- data
学習のデータ置き場で、時刻や写る人のID、それぞれの座標などが記録されている.

- log
学習中の記録置き場で、エポックやロス、エラーがあったかを保存する.

- model
学習済みのAIを保存している.

- plot
可視化結果の保存をしており、グラフや軌跡画像、動画を保存している.

- result
plotとの違いは、plotが人の確認用で、resultはプログラム用.



#align(center)[
  #image("takamiya20260522p1.png", width: 80%)
]

線の意味：\
緑：ped24 の予測軌跡\
桃：ped24 の実際軌跡\
黄：ped25 周囲の歩行者\
青：ped28 周囲の歩行者\
