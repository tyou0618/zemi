#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年7月3日",
)

== 今週行ったこと( 7/3 )
- Social-LSTMの複数回実行(終)
- データセットついて
- 今後の予定

== Social-LSTMの複数回実行(終)
=== 条件と変更箇所

#block()[
  #set text(size: 5pt)
  #figure(
    table(
      columns: (1.8fr, ..range(14).map(_ => 1fr)),
      align: horizon + center,
      stroke: 0.5pt,

      fill: (x, y) => if y >= 2 and calc.odd(y) {
        rgb("#dbe9fe")
      } else {
        none
      },

      // --- 横罫線の配置 ---
      table.hline(y: 0, stroke: 1.5pt),
      table.hline(y: 1, stroke: 0.5pt + rgb("#cccccc")),
      table.hline(y: 2, stroke: 0.8pt),
      table.hline(y: 5, stroke: 1.5pt),

      // ヘッダーエリア（colspan: 2 に修正）
      table.cell(rowspan: 2)[*実験条件 \ 2*],
      table.cell(colspan: 2)[*1回目*],
      table.cell(colspan: 2)[*2回目*],
      table.cell(colspan: 2)[*3回目*],
      table.cell(colspan: 2)[*4回目*],
      table.cell(colspan: 2)[*5回目*],
      table.cell(colspan: 2)[*平均値*],
      table.cell(colspan: 2)[*標準偏差*],

      // 2段目ヘッダー（ご希望の形に修正）
      [*Best \ ADE*], [*Best \ FDE*],
      [*Best \ ADE*], [*Best \ FDE*],
      [*Best \ ADE*], [*Best \ FDE*],
      [*Best \ ADE*], [*Best \ FDE*],
      [*Best \ ADE*], [*Best \ FDE*],
      [*Best \ ADE*], [*Best \ FDE*],
      [*Best \ ADE*], [*Best \ FDE*],

      // --- 1行目 ---
      [batch \ 変更10],
      [17 \ 0.8430], [17 \ 1.6508],
      [27 \ 0.9043], [27 \ 1.7372],
      [25 \ 0.8684], [25 \ 1.6913],
      [23 \ 0.9145], [23 \ 1.7415],
      [17 \ 0.8456], [17 \ 1.6400],
      [21.8 \ 0.8752], [21.8 \ 1.6922],
      [4.60 \ 0.0336], [4.60 \ 0.0468],

      // --- 2行目 ---
      [batch \ 変更12],
      [12 \ 0.8617], [12 \ 1.6895],
      [28 \ 0.9056], [28 \ 1.7206],
      [26 \ 0.8962], [26 \ 1.6859],
      [12 \ 0.9401], [12 \ 1.7940],
      [29 \ 0.8365], [29 \ 1.5752],
      [21.4 \ 0.8880], [21.4 \ 1.6930],
      [7.74 \ 0.0359], [7.74 \ 0.0706],

      // --- 3行目 ---
      [batch \ 変更8],
      [28 \ 0.8696], [28 \ 1.7410],
      [15 \ 0.8832], [15 \ 1.7281],
      [21 \ 0.9897], [21 \ 1.9216],
      [26 \ 0.8759], [26 \ 1.6980],
      [23 \ 0.8394], [23 \ 1.6201],
      [22.6 \ 0.8916], [22.6 \ 1.7418],
      [4.50 \ 0.0513], [4.50 \ 0.0992],
    ),
    caption: [バッチ数変更時における5回の試行と予測精度の推移],
    kind: table,
  )
]

バッチ数を変化させることでADEとFEDに向上が見られると思ったが、
増やしても減らしても特に変化が見られなかった。 \
なのでこれからの基準値としては、epochs 30, learn rate 0.003, batch 10
の値で取り組む。

#pagebreak()

== データセットについて
=== 既存のデータセット
- BIWI (ETH)
ETH（歩道）、Hotel（ホテル前）の2種類を使用。歩行者数は5〜20人程度で、歩行方向がある程度決まっている比較的簡単な軌跡予測になるデータセット。今まではこのデータセットのみを使用していた。

- Crowds (UCY)
3種類を使用。BIWIより人が多く、人が交差したり、急な方向転換が増える。

- Stanford Drone Dataset (SDD)
多種類を使用。ドローン視点で撮影されており、先ほどの二つよりも人数が多く、人以外にも自転車も登場している。


== 今後の予定
- もう少し数値を変更して実験してみる
- 現在のデータセットではなく、外部にあるデータセットを用いて実装する
- Yolo と接続して動画から人物の座標を取得し、取得した座標をもとにSocial-LSTMの実行を行う
