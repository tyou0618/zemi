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
== Social-lstmの評価
- 旧Social-LSTM、等速直線予測、改善Social-LSTMの3つの方法で、20秒の動画用いた比較実験を行なった
  - 改良自体には効果があり、旧モデルより良くなったが、等速直線予測にはまだ負けている
\
#table(
  columns: (1.7fr, 1fr, 1fr, 1fr, 1fr),
  inset: 5pt,
  align: (left, right, right, right, right),
  table.header([方法], [ADE], [FDE], [RMSE], [中央値]),
  [旧Social-LSTM], [1.358 m], [2.689 m], [2.182 m], [0.627 m],
  [改良Social-LSTM], [0.964 m], [1.810 m], [1.603 m], [0.480 m],
  [*等速直線予測*], [*0.655 m*], [*1.241 m*], [*1.141 m*], [*0.355 m*],
)
- 現在動画はh1という5分の動画とそれの切り抜きでh2,h3、h4という5分の別動画とそれの切り抜きでh5の動画がある
  - 前回まではh12を使用していたが、今回はh12・h13・h14・h15も使用できるように変換を行なった

- 公開データを使ったモデルと撮影動画の混合ファインチューニングを行なった
  - h14を学習重みとして使い、h13でテストを行なった

#table(
  columns: (1.8fr, 1fr, 1fr, 1fr, 1fr),
  inset: 5pt,
  align: (left, right, right, right, right),
  table.header([モデル], [ADE], [FDE], [RMSE], [中央値]),
  [元モデル], [0.504 m], [1.183 m], [1.040 m], [0.100 m],
  [h14単独], [0.621 m], [1.444 m], [1.191 m], [0.106 m],
  [*混合モデル*], [*0.472 m*], [*1.143 m*], [*1.013 m*], [*0.096 m*],
)

= 今後の予定
- 改善モデルを使った予測評価の確認


