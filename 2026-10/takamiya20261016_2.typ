#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年10月16日",
)

== 今週行ったこと( 10/16 )
- social-lstmの改良
- 座標データの追加
- 今後の予定



== social-lstmの改良
- Social Gridの大きさをピクセルからメートルに変換した

- 軌跡の読み取り間隔0.4秒間隔に合わせて動画も再標本化した

- 座標の信頼性向上のため、座標の分割と除外を行った

- CSVファイルにまとめる情報量を増やした



== 座標データの追加
- 大学内の動画以外に撮影を行い、現在座標データを追加中

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261016p1.JPG", height: 70pt)#text(6pt, "阪急 梅田駅 改札前広場")],
    [#image("takamiya20261016p2.JPG", height: 70pt)#text(6pt, "阪急百貨店と阪急三番街の間の通路")],
    [#image("takamiya20261016p3.JPG", height: 70pt)#text(6pt, "阪急百貨店からJR大阪駅までの通路")],
  )
]

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261016p4.JPG", height: 70pt)#text(6pt, "阪急百貨店からJR大阪駅までの交差点")],
    [#image("takamiya20261016p5.JPG", height: 70pt)#text(6pt, "阪急百貨店外側歩道")],
    [#image("takamiya20261016p6.JPG", height: 70pt)#text(6pt, "ヨドバシカメラ 梅田店前のスクランブル交差点")],
  )
]



== 今後の予定
- 座標データ完成及び新規データで動作確認
- 複数のデータでsocial-lstmの実装を行う
