#import "@preview/codelst:2.0.2": sourcecode

#set text(font: "IPAexMincho", 12pt, weight: "black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em),
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)
#show "、": ", "
#show "。": ". "
#set page(paper: "a4", flipped: true)

#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年   月   日  923044 髙宮 悠聖")
]
= 現在の進行状況
== コードの変更2

#block()[
  #set text(size: 8pt)
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

== 結果からの考察
バッチ数を変化させることでADEとFEDに向上が見られると思ったが、
増やしても減らしても特に変化が見られなかった。 \
なのでこれからの基準値としては、epochs 30, learn rate 0.003, batch 10
の値で取り組む。


= 今後の予定
- 今までは同じデータセットで学習していたので、他のデータセットを探して使用してみる
