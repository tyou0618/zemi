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
== コードの変更

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
      table.hline(y: 9, stroke: 1.5pt),

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

      // ==========================================
      // データエリア（各マスに「 \ 」で上下2段にして流し込み）
      // ==========================================

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
      [batch \ 変更15],
      [21 \ 0.9522], [21 \ 1.8592],
      [21 \ 0.9562], [21 \ 1.8861],
      [10 \ 0.9490], [10 \ 1.8196],
      [15 \ 0.9261], [15 \ 1.8265],
      [29 \ 0.9092], [29 \ 1.7370],
      [xx.x \ 0.0000], [xx.x \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],

      // --- 3行目 ---
      [batch \ 変更12],
      [12 \ 0.8617], [12 \ 1.6895],
      [28 \ 0.9056], [28 \ 1.7206],
      [26 \ 0.8962], [26 \ 1.6859],
      [12 \ 0.9401], [12 \ 1.7940],
      [29 \ 0.8365], [29 \ 1.5752],
      [xx.x \ 0.0000], [xx.x \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],

      // --- 4行目 ---
      [e: l:  b: ],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [22.6 \ 0.8982], [22.6 \ 1.7471],
      [6.27 \ 0.0386], [6.27 \ 0.0739],

      // --- 5行目 ---
      [e: l:  b: ],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],

      // --- 6行目 ---
      [e: l:  b: ],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],

      // --- 7行目 ---
      [e: l:  b: ],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx \ 0.0000], [xx \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],
      [xx.x \ 0.0000], [xx.x \ 0.0000],
    ),
    caption: [各パラメータ変更時における5回の試行と予測精度の推移],
    kind: table,
  )
]

== 結果からの考察
- epochを30→60に増やしてもほぼ改善しない
- epoch=60は安定性が悪い
- 学習率0.006は意外と良く収束が早い
