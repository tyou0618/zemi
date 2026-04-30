#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font:"Noto Serif JP",10pt,weight:"black")
#set par(first-line-indent:(amount:1em,all: true),justify: true)
#show raw.where(block: true): it => block(
  fill: luma(240),          // 薄いグレーの背景
  inset: 3pt,              // 内側の余白
  radius: 6pt,              // 角を丸くする
  width: 100%,              // 横幅いっぱい
  stroke: 0.5pt + luma(200) // 薄い枠線
)[
  #set text(size: 7pt, font: "DejaVu Sans Mono") // コードのフォントサイズと種類
  #it
]


#show: slides.with(
  title:"全体ゼミでの振り返り",
  authors: "923044 高宮悠聖", 
  // subtitle: "サブタイトルが必要な場合はここ",
  date: "2026年4月24日")


== 今週行ったこと( 4/24 )
- Yoloについて

== Yoloについて
- yoloのv8と11を導入した
  - その2種は同じ会社がシステム作成しておりpipで導入可能
  - 実行方法も比較的簡単なので難易度が低め

- 実行自体は以下のコードが主になる
#figure(
  raw("
from ultralytics import YOLO 

results = model(    # YOLO の推論
  img,    # 入力画像名
  save=True,  # 結果を保存するかどうか
  project=save_project,   # 保存先フォルダ名、結果をまとめるフォルダ名
  name=save_name  # サブフォルダ名、実験ごとのフォルダ名
  )

", lang: "python", block: true),
) <yolo-script>

\

