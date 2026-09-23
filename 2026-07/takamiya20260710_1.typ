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
- Social-LSTMを複数回実行し、バッチ数を変えて予測精度を比較した。
  大きな差は見られなかったため、当面はepochs 30、learning rate 0.003、batch 10を基準に進める。

- これまでは主にbiwi_hotelを使用していた。
  ほかの場面でも評価できるよう、データセットを増やす準備を進める。

- YOLOで検出した人物の座標をSocial-LSTMにつなぐ方法を確認している。
  理解が曖昧な部分があるため、Social-LSTMの論文を読み直す。

= 今週進めること
- arxiepiskopi1、crowds_zara02、crowds_zara03、bookstore_0を追加し、ADE・FDEを比較する。

- 論文を読み直しながら、YOLOの検出結果から座標を取得してSocial-LSTMへ渡すまでの処理を整理する。

- 整理できた部分から、プログラムの接続方法を検討する。
