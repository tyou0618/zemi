#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年10月02日",
)

== 今週行ったこと( 10/2 )
- 撮影場所確定(大学内)
- ホモグラフィ変換の実装中
- その他
- 今後の予定

== 撮影場所確定(大学内)
- 大阪工業大学 梅田キャンパス 茶屋町側出入り口前撮影
  - 撮影時刻: 2026年9月29日 15時08分 〜 15時23分 ~ 15分間

- 使用アプリ: Appleのアプリ「計測」

- 撮影場所のポイント
  - 人の通りが比較的少なく壁のない開放的な空間

#align(center)[
  #image("takamiya20261002p3.jpg", height: 60%)
]


#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261002p1.jpg", height: 78pt)], [#image("takamiya20261002p2.jpg", height: 78pt)],
  )
]

#align(center)[
  #image("takamiya20261002p4.jpg", height: 135pt)
]

== ホモグラフィ変換の実装中
- 実測地の座標化とピクセル値の座標化
  - 左下を基準として右方向にx軸プラス、上方向にy軸プラス
  - 座標はタイル上の線を基準として置いている
  - 全部の点を変換に使用するのではなく、端の何点かを使用、他は検証用で使おうと考えている
- 現在CSVファイルにまとめ中
#align(center)[
  #image("takamiya20261002p5.jpg", height: 140pt)
]


== その他
- 事務バイトが木曜午前に変更になった

- 今週木曜から剛先生のヒューマンセンシング論を先取り授業として行った
  - 久々の授業でかなり忘れていることが多かった
  - 置いて行かれないように復習しながら取り組もうと思う


== 今後の予定
- ホモグラフィー変換を実装してm変換を使えるようにする
- Social-LSTMの実装
