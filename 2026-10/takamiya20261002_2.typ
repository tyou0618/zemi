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
- ホモグラフィ変換の実装
- その他
- 今後の予定

== 撮影場所確定(大学内)
- 大阪工業大学 梅田キャンパス 茶屋町側出入り口前撮影
  - 撮影時刻: 2026年9月29日 15時08分 〜 15時23分 ~ 15分間

- 使用アプリ: Appleのアプリ「計測」

- 撮影場所のポイント
  - 人の通りが比較的少なく壁のない開放的な空間

#align(center)[
  #image("takamiya20261002p3.jpg", height: 75%)
]
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261002p1.jpg", height: 78pt)], [#image("takamiya20261002p2.jpg", height: 78pt)],
  )
]

#align(center)[
  #text(size: 8pt)[大学内の撮影候補場所]
]

== 撮影場所の下見
- 阪急梅田付近の撮影候補
- 屋内通路、屋外通路、横断歩道など、異なる環境を確認した
- 通行者が多く、歩行方向の交差や混雑を含む映像を撮影できる




== その他
- 2026年9月24日に大学で行われた避難訓練に参加した
- 訓練後に非常食と非常用飲料水を受け取った


== 今後の予定
- 実空間の計測
- ホモグラフィー変換で足元の座標を実空間の座標に変換する
