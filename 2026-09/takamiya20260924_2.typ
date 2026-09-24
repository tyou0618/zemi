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




== その他




== 今後の予定
- 使用するデータセットを決め、YOLOの人物検出とByteTrackのID追跡を安定させる
- 検出枠の下端から足元の座標を取得し、人物ごとの軌跡を確認する
- ホモグラフィー変換で足元の座標を実空間の座標に変換する
- Social-LSTMによる未来位置の予測と、心理バイアスの追加に進む
