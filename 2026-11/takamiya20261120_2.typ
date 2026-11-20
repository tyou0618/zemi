#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年11月20日",
)

== 今週行ったこと( 11/20 )
- Social-LSTMシステムの改良
- 今後の予定

== Social-LSTMシステムの改良
問題点と対策 1
- ByteTrackが付与するtrack_idだけでは、追跡途切れやID再利用した場合に、
  時間的に連続していない区間を一本の軌跡として接続していた
- 不連続になった位置ごとにsegment_idを付与し、
  (track_id, segment_id)の組で一つの連続軌跡を識別した
  - 変更したものの結果には特に変化なし

問題点と対策 2
- 計測結果が異常な移動速度になっていたり、予測モデルがすぐ過学習になったりした
- 学習設定の変更として、最大エポックや学習率を小さくしたり、異常速度や軌跡になった場合は学習窓から除外したり、検証損失が連続で改善しなければ学習を終了するようにしたりした

#pagebreak()

- 改善後のSocial-LSTMの評価結果
#table(
  columns: (0.5fr, 0.5fr),
  inset: 4pt,
  align: (left, right),
  table.header([項目], [結果]),
  [最大エポック], [30],
  [実際の学習], [9エポック],
  [最良エポック], [4],
  [最良検証損失], [-0.17047],
  [最終学習率], [0.00005],
)

- それぞれの評価結果
#table(
  columns: (1.7fr, 1fr, 1fr, 1fr, 1fr),
  inset: 5pt,
  align: (left, right, right, right, right),
  table.header([方法], [ADE], [FDE], [RMSE], [中央値]),
  [旧Social-LSTM], [0.738 m], [1.655 m], [1.309 m], [0.182 m],
  [等速直線予測], [0.618 m], [1.372 m], [1.249 m], [0.203 m],
  [*改良Social-LSTM*],
  [*#text(fill: red)[0.504] m*],
  [*#text(fill: red)[1.183] m*],
  [*#text(fill: red)[1.040] m*],
  [*#text(fill: red)[0.100] m*],
)

#pagebreak()

問題点と対策 3
- 短い動画用いた比較実験を行なった場合は改良Social-LSTMが優れた結果を出したが、長い動画を用いた場合は等速直線予測の方が優れた結果を出した
#table(
  columns: (1.7fr, 1fr, 1fr, 1fr, 1fr),
  inset: 5pt,
  align: (left, right, right, right, right),
  table.header([方法], [ADE], [FDE], [RMSE], [中央値]),
  [旧Social-LSTM], [1.358 m], [2.689 m], [2.182 m], [0.627 m],
  [改良Social-LSTM], [0.964 m], [1.810 m], [1.603 m], [0.480 m],
  [*等速直線予測*],
  [*#text(fill: red)[0.655] m*],
  [*#text(fill: red)[1.241] m*],
  [*#text(fill: red)[1.141] m*],
  [*#text(fill: red)[0.355] m*],
)

- 今までは1つの撮影データを使用していたが、他のデータも使えるように変換を行なった
- 公開データを使ったモデルと撮影動画の混合ファインチューニングを行なった

#pagebreak()

- それぞれのモデル評価結果
#table(
  columns: (1.8fr, 1fr, 1fr, 1fr, 1fr),
  inset: 5pt,
  align: (left, right, right, right, right),
  table.header([モデル], [ADE], [FDE], [RMSE], [中央値]),
  [元モデル], [0.504 m], [1.183 m], [1.040 m], [0.100 m],
  [h14単独], [0.621 m], [1.444 m], [1.191 m], [0.106 m],
  [*混合モデル*],
  [*#text(fill: red)[0.472] m*],
  [*#text(fill: red)[1.143] m*],
  [*#text(fill: red)[1.013] m*],
  [*#text(fill: red)[0.096] m*],
)


== 今後の予定
現在、カメラ映像からSocial-LSTMによる将来軌跡予測まではできている\
(予測精度は改善の余地あり)
\
歩行者同士の接近・回避行動候補の抽出、動画内の環境を特徴量化、回避行動の予測及び理由の推定、心理バイアスの確率出力などを今後作成する予定
