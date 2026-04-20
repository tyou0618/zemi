#set text(font:"Noto Serif JP",12pt,weight:"black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em)
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)

#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年   月   日  髙宮 悠聖")
]

= 類似研究調べ
== Occupancy Estimation from Blurred Video: A Multifaceted Approach with Privacy Consideration(2024年)
- 概要
室内にいる人数をカメラで自動計測する研究\
カメラのレンズを意図的にぼかして撮影することで、個人の特定を防ぎつつ、人数だけを正確に把握する、というプライバシー保護とデータ活用の両立を目指している研究.
- 考えられる新規性
この研究では、優れたカメラを一度ぼかすことでプライバシー保護を行おうとしている\
→元から低画質かつ情報が映像しかないライブカメラを使用することで差別化、実用性の向上\
この研究では、予め用意したカメラを使用し、研究環境も部屋の中に限定されている\
→屋外などの密閉されていない環境でも使用可能にする
- https://pmc.ncbi.nlm.nih.gov/articles/PMC11207467/
\
== Content-aware Density Map for Crowd Counting and
Density Estimation(2019年)
- 概要
混雑した場所での人数カウントと密度マップ生成を行う研究\
従来の研究では、頭を検知してカウントしていたがそれだと頭の大きさや距離を無視しているのでノイズが増えたり、密集しすぎると破綻する可能性があった.なので頭の領域を取得しガウシアンを作成することでより正確な密度マップを作成可能.
- 考えられる新規性
この研究では、静止画でのみの実装\
→動画から切り取った画像を都度密度マップ作成できるように軽量化\
→動画を切り取ることでの時系列の変化を取り込む
- https://arxiv.org/pdf/1906.07258