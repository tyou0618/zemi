#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 10pt, weight: "black")
#set par(first-line-indent: (amount: 1em, all: true), justify: true)

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  // subtitle: "サブタイトルが必要な場合はここ",
  date: "2026年5月22日",
)


== 今週行ったこと( 5/22 )
- 実際にSocial-LSTMを動かしてみた

== 実際にSocial-LSTMを動かしてみた
=== 実装方法
- Social-LSTMをダウンロード
  - github.com/quancore/social-lstm.git
- VScodeを使用
- install torch torchvision numpy pandas \
  matplotlib adjustText imageio
  - torch:PyTorch、AIの計算（ニューラルネットワーク）動作用
  - torchvision:PyTorchで画像や動画を扱うための補助ライブラリ
  - numpy:超高速で数字のリストを計算するライブラリ
  - pandas:データを表形式で扱える
  - matplotlib:データをグラフや図として画面に描画するライブラリ
  - adjustText:グラフに描かれた文字を自動で配置を調整するライブラリ
  - imageio:大量の画像を読み込んでGIFやMP4に合体・変換するライブラリ
- 実行
  - train.py:学習を実行するためのプログラム
  - visualize.py:予測結果を見るためのプログラム
- 実装結果
#align(center)[
  #image("takamiya20260522p1.png", width: 80%)
]

線の意味：\
緑：ped24 の予測軌跡\
桃：ped24 の実際軌跡\
黄：ped25 周囲の歩行者\
青：ped28 周囲の歩行者\

- なぜ有効か
#align(center)[
  #image("takamiya20260522p3.png", width: 65%)
]
#align(center)[
  #image("takamiya20260522p4.png", width: 65%)
]
