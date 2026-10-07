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
== ホモグラフィ変換の実装
- 計算用と検証用の2種類の点に分けた
  - 計算用 10点 検証用 15点
- ホモグラフィ変換の計算結果を用いてグリッド作成
  - 平均誤差 約2cm 最大誤差 約6cm
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 30pt,

    [#image("takamiya20261009p1.png", width: 230pt)], [#image("takamiya20261009p2.png", width: 230pt)],
  )
]

\

== yoloからホモグラフィ変換までの実行
- social-lstmの前に一連の動作を実行
  - 検証動画:19秒の動画 一人が移動するだけ
  - 高信頼度で検知かつ途切れず追跡できていた

- 計測結果
  - 追跡時間：約3.69秒
  - 移動距離：約4.12 m
  - 概算速度：約1.12 m/s

- 問題点
  - 最大瞬間速度：約6.15 m/s
  - YOLOのbbox下辺がフレームごとに数ピクセル動くことで速度が大きくなったと予想
  - 軌跡の平滑化が必要

= 今後の予定
- 計測値の整理と撮影データと計測値の合致
- ホモグラフィ変換の実装
