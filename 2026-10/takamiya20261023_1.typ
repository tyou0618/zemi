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
== 動画データの追加
- 10月17日: 淀川花火大会による増加した歩行者データの追加を行った
  - すでに撮影していた動画の比較になるように、同じ場所で６箇所撮影を行った
  - ただし、正確に等しい画角ではないため、ホモグラフィ行列の流用はできない

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261023p1.png", height: 120pt)#text(12pt, "平日 10時頃")],
    [#image("takamiya20261023p2.png", height: 120pt)#text(12pt, "花火大会当日 18時頃")],
  )
]

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [
      == ホモグラフィ変換の簡易化
      今までは画像に直接点を打ち、距離とピクセル値を手動でcsvにしていた

      \

      ホモグラフィ変換の効率化を図るため、AIに変換用システムの作成をしてもらった
    ],
    [#image("takamiya20261023p3.png", height: 120pt)],
  )
]
できること: \
実測座標を入力 , CSV・Excelから点を読み込む , 画像上でピクセル位置を指定 , \
点の修正・削除・並べ替え , 計測用と確認用に分割 , Homography行列の計算 , \
点ごとの誤差計算 , 地面のグリッドを表示 , メートル軌跡をCSVと画像で保存 , \
保存済みプロジェクトを再編集


= 今後の予定
- Scial-lstmの作業続き
