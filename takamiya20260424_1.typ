#set text(font:"Noto Serif JP",12pt,weight:"black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em)
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)

#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年   月   日  髙宮 悠聖")
]

= 類似研究調べ
== 全天球カメラを用いたリアルタイム行列検知 (2021年)

- 概要
全天球カメラを用いて行列を検知する研究\
並んでる列は全員同じ方向をむくので、人の方向を検知することで混雑度を予測することを目的としている.しかし全天球カメラではカメラで読み取れる人の方向と実際の人の方向は異なるため、実際の人物方向を検知し行列を検知するシステムを作成していた研究.

- 考えられる新規性
この研究では、あくまで人の方向が直線的かどうかを判断するだけのシステム\
→長蛇の列だと蛇腹状になったりするので直線でなくても検知するシステムの作成\
この研究では、ひとつの列に対してだけの検知を行っている\
→複数の列を検知しカテゴリ別に分けれるようにする

#align(center)[
#image("takamiya20260424p1.png", width: 80%)
]


- https://proceedings-of-deim.github.io/DEIM2021/papers/J13-5.pdf
\
== 今後の予定
複数の類似研究の論文を読んだところ、基本的にYou Only Look Once(Yolo)のアルゴリズムを使用している.なのでとりあえず研究室のパソコンで導入して使用してみる.Yoloにもv1からv12くらいまであるので、どう違うのか調べつつ使用感を見る.