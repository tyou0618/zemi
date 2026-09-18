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

== 長期休み期間で行ったこと( 9/18 )
- 研究の進行順序の決定
- YoloとByteTrackの連携
- 今後の予定

== 研究の進行順序の決定
#align()[ #text(10pt, "1.YOLO人物検出") ]
#align()[ #text(10pt, "2.ByteTrack ID追跡") ]
#align()[ #text(10pt, "3.足元の座標取得") ]
#align()[ #text(10pt, "4.Homographyによるメートル座標変換") ]
#align()[ #text(10pt, "5.Social-LSTMによる未来予測") ]
#align()[ #text(10pt, "6.心理バイアスの追加") ]

== YoloとByteTrackの連携
- YOLOの検出結果をByteTrackへ渡し、人物ごとにIDを付けて追跡する構成を試した
- しかし、検出漏れや誤検出が追跡に影響し、IDの維持が安定しなかった
- まずYOLO単体の検出結果を確認し、問題を切り分けた
- 評価用動画を4本用意し、CVATで人物の正解データを作成した
- 信頼度の調整をした

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 8pt,
    image("takamiya20260918p1.png", width: 100%), image("takamiya20260918p2.png", width: 100%),
  )
]


== YoloとByteTrackの連携：検出と追跡の確認
- YOLOを11nから11sに変更し、人物検出の改善を試した


#align(center)[
  #image("takamiya20260918p3.png", height: 78%, fit: "contain")
]
#align(center)[#text(8pt, "色付きの枠とID: ByteTrack / 赤点: 足元の座標")]

== YoloとByteTrackの連携：動画ごとの違い
- 撮影方向や人物の大きさが異なる動画で、検出・追跡結果を比較した
- 人物が小さい映像や、人が重なる場面では、検出とID保持の調整に苦戦した

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 8pt,
    image("takamiya20260918p4.png", height: 75%, fit: "contain"),
    image("takamiya20260918p5.png", height: 75%, fit: "contain"),
  )
]
#align(center)[#text(8pt, "異なる動画でのYOLOとByteTrackの出力例")]

== 今後の予定
- 使用するデータセットを決め、YOLOの人物検出とByteTrackのID追跡を安定させる
- 検出枠の下端から足元の座標を取得し、人物ごとの軌跡を確認する
- ホモグラフィー変換で足元の座標を実空間の座標に変換する
- Social-LSTMによる未来位置の予測と、心理バイアスの追加に進む
