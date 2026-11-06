#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年11月06日",
)

== 今週行ったこと( 11/6 )
- 倫理申請書の完成
- Social-LSTMシステムの改良
- 今後の予定

== 倫理申請書の完成
- 提出期限ギリギリになったがなんとか新規申請書と説明書を完成させた
- 申請書に記述した実験はシステムのプロトタイプが出来次第行う予定
#align(center)[
  #image("takamiya20261106p4.png", height: 130pt)
]

== Social-LSTMシステムの改良
=== ホモグラフィ変換の修正
- 作成自体はできていたが誤差が大きかったり少しずつずれたりが多かった
- 改めて計測を行い、数値の訂正、点の増加を行った
- 最大誤差は増えたが、平均誤差は減った
- 右側と奥行きに変換可能領域が増えたことでより詳細な歩行者軌跡を計測できるようになった

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261106p1.png", height: 120pt)#text(10pt, "修正前")],
    [#image("takamiya20261106p2.png", height: 120pt)#text(10pt, "修正後")],
  )
]

=== ポリゴンでの領域指定
- CVATで作成したポリゴンを使い、人物の足元が歩行可能領域内にある場合だけYOLO検出をByteTrackへ渡すようにした

#align(center)[
  #image("takamiya20261106p3.png", height: 160pt)#text(9pt, "領域指定")
]


== 今後の予定
- Social-LSTMの実装続行
- 実験準備
