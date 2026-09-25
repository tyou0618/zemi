#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年9月18日",
)

== 今週行ったこと( 9/24 )
- 撮影場所の下見
- その他
- 今後の予定

== 撮影場所の下見
- 大学内を撮影候補として下見した
- 上の階から撮影できるため、歩行者を見下ろす映像を撮影できる
- 床が平らで区切りも確認しやすく、座標変換に必要な基準点を設定しやすい
- 普段は通行者が少ないため、多人数の歩行データを集めるには撮影時間や協力者の検討が必要


#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20260924p1.png", height: 78pt)],
    [#image("takamiya20260924p2.png", height: 78pt)],
    [#image("takamiya20260924p3.png", height: 78pt)],
  )
]

#align(center)[
  #text(size: 8pt)[大学内の撮影候補場所]
]

== 撮影場所の下見
- 阪急梅田付近を撮影候補として下見した
- 屋内通路、屋外通路、横断歩道など、異なる環境を確認した
- 通行者が多く、歩行方向の交差や混雑を含む映像を撮影できる
- 高い位置から撮影できる場所があり、人物の動きや足元を確認しやすい
- 場所によって人数や撮影角度が異なるため、YOLOとByteTrackの比較にも利用できる

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 4pt,
    [#image("takamiya20260924p4.png", height: 63pt)],
    [#image("takamiya20260924p5.png", height: 63pt)],
    [#image("takamiya20260924p6.png", height: 63pt)],

    [#image("takamiya20260924p7.png", height: 63pt)],
    [#image("takamiya20260924p8.png", height: 63pt)],
    [#image("takamiya20260924p9.png", height: 63pt)],
  )
]
#align(center)[#text(8pt, "阪急梅田付近の撮影候補場所")]

== その他
- 2026年9月24日に大学で行われた避難訓練に参加した
- 訓練後に非常食と非常用飲料水を受け取った

#align(center)[
  #image("takamiya20260924p10.png", height: 55%, fit: "contain")
]
#align(center)[#text(8pt, "避難訓練後に受け取った非常食と非常用飲料水")]

== 今後の予定
- 使用するデータセットを決め、YOLOの人物検出とByteTrackのID追跡を安定させる
- 検出枠の下端から足元の座標を取得し、人物ごとの軌跡を確認する
- ホモグラフィー変換で足元の座標を実空間の座標に変換する
- Social-LSTMによる未来位置の予測と、心理バイアスの追加に進む
