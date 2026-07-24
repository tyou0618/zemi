#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年7月24日",
)

== 今週行ったこと( 7/24 )
- 論文読解
- ワークショップ
- 今後の予定


== 論文読解
論文を改めて全部読み直した\
改めて読み直した結果、Yoloと Social LSTMを直接接続する前にYoloとトラッキングシステムを先に接続しなければならなかった\
以下のサイトを参考にトラッカーを接続する予定
- 読んでいた論文ではDeepSORTを使用していた
- サイトやAIではDeepSORTよりByteTrackをおすすめしていた


+ ByteTrack vs DeepSORT vs OC-SORT 現場で使うならどれ？SORT系トラッカー5種の選び方〜前編〜\
  https://www.mukuil.com/column/bytetrack-vs-deepsort-vs-oc-sort/

+ DeepSORTの実装方法\
  https://qiita.com/sujan/items/a25e74c83ea6425185a4

+ ByteTrackの実装方法\
  https://www.kkaneko.jp/ai/labo/trackyolov12det.html\
  https://docs.ultralytics.com/ja/modes/track

== ワークショップ

#grid(
  columns: (6cm, 1fr),
  gutter: 1pt,
  align: top,

  image("work shop.png", width: 100%),

  [
    8月6日、7日(木、金)のワークショップに\
    参加する\
    二日目の競技会に向けてルール作成及び、\
    競技に向けたプログラムの参考例の作成を\
    行なっている\
    2日目16時半から行われるロボット見学でS科展示を行うか考え中


  ],
)
== 今後の予定
- トラッカーを接続する予定
- ワークショップ案を考える
