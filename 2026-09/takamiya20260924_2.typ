#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年9月25日",
)

== 今週行ったこと( 9/25 )
- 撮影場所の下見
- その他
- 今後の予定

== 撮影場所の下見
- 大学内の撮影候補
- 通行者が少ないときもあるため、多人数の歩行データを集めるには撮影時間や協力者の検討が必要


#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20260924p1.jpg", height: 78pt)],
    [#image("takamiya20260924p2.jpg", height: 78pt)],
    [#image("takamiya20260924p3.jpg", height: 78pt)],
  )
]

#align(center)[
  #text(size: 8pt)[大学内の撮影候補場所]
]

== 撮影場所の下見
- 阪急梅田付近の撮影候補
- 屋内通路、屋外通路、横断歩道など、異なる環境を確認した
- 通行者が多く、歩行方向の交差や混雑を含む映像を撮影できる

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 4pt,
    [#image("takamiya20260924p4.jpg", height: 63pt)],
    [#image("takamiya20260924p5.jpg", height: 63pt)],
    [#image("takamiya20260924p6.jpg", height: 63pt)],

    [#image("takamiya20260924p8.jpg", height: 63pt)],
    [#image("takamiya20260924p7.jpg", height: 63pt)],
    [#image("takamiya20260924p9.jpg", height: 63pt)],
  )
]
#align(center)[#text(8pt, "阪急梅田付近の撮影候補場所")]

== その他
- 2026年9月24日に大学で行われた避難訓練に参加した
- 訓練後に非常食と非常用飲料水を受け取った

#align(center)[
  #image("takamiya20260924p10.jpg", height: 75%, fit: "contain")
]
#align(center)[#text(8pt, "避難訓練後に受け取った非常食と非常用飲料水")]

== 今後の予定
- 実空間の計測
- ホモグラフィー変換で足元の座標を実空間の座標に変換する
