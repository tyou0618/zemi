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
  #text(12pt, "2026年   月   日  923044 髙宮 悠聖")
]

= 現在の進行状況
== Social-LSTM プログラム把握
- 内容を変更するにあたって使用するプログラムの中身を確認
  - コメントアウトで分かりやすいように説明を記述
  #align(center)[
    #image("takamiya20260529p1.png", width: 100%)
  ]

== システム内容
+ 人の座標を入力
  - $(x_t^i, y_t^i)$ , $i$ : 人物番号 , $t$ : 時刻

+ 各人物ごとにLSTMを持つようにする
  - LSTM:歩く速度、曲がり方、加速、減速などを記憶


+ Social Poolingを使う
  - Social Pooling:周囲の人のLSTM状態(hidden state)を共有するシステム
  - $H_t^i (m,n,:) = sum_(j in N_i)1_(m n)[x_t^j - x_t^i, y_t^j - y_t^i]h_(t-1)^j$
  $H_t^i (m,n,:)$ \
  時刻tのときi番目の人がグリッド位置m,n内にいるときのhidden state を集めた周囲情報マップ\
  $sum_(j in N_i)1_(m n)[x_t^j - x_t^i, y_t^j - y_t^i]h_(t-1)^j$\
  i番目の人の近くにいる人が縦横どのくらいの距離にいるか,(m,n)マスにいるのか,いるならその人のLSTM記憶(hidden state)をまとめる


+ LSTMに周囲情報を入力
  - 現在位置 + 周囲の人の状態 → LSTM更新 → 次の位置予測
  - $e_t^i = phi (x_t^i , y_t^i; W_e)$ : 座標を特徴ベクトルに変換する式
  - $a_t^i = phi (H_t^i; W_a)$ : 周囲の人の hidden state を位置ごとに並べる式
  - $h_t^i ="LSTM" (h_(t-1)^i, e_t^i, a_t^i; W_l)$ :
  前回LSTM、自分の位置情報、周囲の人情報を組み合わせてLSTM更新

+ 次の位置を確率分布として予測
  - 二次元ガウス分布を使用
$ (hat(x), hat(y))_t^i ~ N(mu_t^i, sigma_t^i, rho_t^i) $ \
$mu_t^i$ : 予測位置の中心 , $sigma_t^i$ : 予測の広がり , $rho_t^i$ : x方向とy方向の関連
= 今後の予定
- 使用するプログラムの中身確認の続き
- 数値変えて何回か実行
