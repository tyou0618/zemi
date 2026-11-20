#set text(font: "IPAexMincho", 12pt, weight: "black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em),
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)

#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年 月 日  923044 髙宮 悠聖")
]
= 現在の進行状況

== 歩行者の軌跡予測
- Social-LSTMの論文を読み直し、カメラ映像から得た人物の座標を予測モデルに渡すまでの処理を整理した。
- YOLOの検出結果から軌跡を作るには、フレームをまたいで同じ人物を対応付ける必要がある。YOLOとSocial-LSTMの間にトラッカーを入れ、人物IDごとに座標を時系列に並べる方針とした。
- 参考にした論文ではDeepSORTが使われていた。実装例を確認し、まずはByteTrackをYOLOと組み合わせて試す予定である。

== ワークショップの準備
- 8月6日・7日のワークショップに向けて、2日目の自律走行ロボット競技のルール案と、参加者が参照できるプログラム例を作成している。
- 2日目のロボット見学でS科の展示を行うか検討している。

= 今後の予定
- YOLOにByteTrackを接続し、人物IDごとに座標を記録できるか確認する。得られた座標列をSocial-LSTMの入力形式に合わせる方法を整理する。
- ワークショップの競技ルール案を詰め、参考プログラムの準備を進める。
