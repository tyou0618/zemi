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
=== 1.YOLO人物検出
=== 2.ByteTrack ID追跡
=== 3.足元の座標取得
=== 4.Homographyによるメートル座標変換
=== 5.Social-LSTMによる未来予測
=== 6.心理バイアスの追加

== YoloとByteTrackの連携
-
- Yoloは11nから11sに変更
- ByteTrackがうまく動作せず、ID保持ができなかった

== 今後の予定
- データセットの変更
- Yolo 接続から座標取得

#align()[ #text(10pt, "[システム最終形]") ]
カメラ\
↓\
OpenCV(動画を1フレームずつ取得)\
↓\
YOLOv5(人物検出)\
↓\
ByteTrack(人物追跡)\
↓\
Social-LSTM(未来12フレーム予測)\
追加:心理バイアス\
↓\
予測可視化
