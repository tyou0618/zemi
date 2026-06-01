#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 10pt, weight: "black")
#set par(first-line-indent: (amount: 1em, all: true), justify: true)

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  // subtitle: "サブタイトルが必要な場合はここ",
  date: "2026年5月29日",
)


== 今週行ったこと( 5/29 )
- プログラムの内容確認
- アプリ作成

== プログラムの内容確認
=== ソースコード確認
- 内容を変更するにために使用するプログラムの内容を確認
  - コメントアウトで分かりやすいように説明を記述
  #align(center)[
    #image("takamiya20260529p1.png", width: 85%)
  ]

#pagebreak()

=== 式確認
$ H_t^i (m,n,:) =sum_(j in N_i)1_( m n )[x_t^j-x_t^i, y_t^j-y_t^i]h_(t-1)^j $

#text(size: 8pt)[
  $H_t^i (m,n,:)$ ： \
  時刻tのときi番目の人が,グリッド位置m,n内にいるときのhidden state を集めた周囲情報マップ\

  $sum_(j in N_i)$： iの近くにいる周囲の人jたち全員を足し合わせる

  $x_t^j-x_t^i, y_t^j-y_t^i$ ： jがiから見て縦横にどれだけ離れてるか

  $1_(m n)[...]$ ： 指示関数,jが(m,n)マスにいたら1,違えば0,

  $h_(t-1)^j$ ： j番目の人のLSTM記憶
]
#align(center)[
  #image("takamiya20260529p5.png", width: 80%)
]

$ e_t^i = phi (x_t^i, y_t^i; W_e) $
#text(size: 8pt)[
  $e_t^i$ ： 自分の位置特徴ベクトル \

  $x_t^i, y_t^i;$ ： i番目の人の現在座標\

  $phi ()$ ： 変換関数,線形変換 + 活性化関数(ReLU)\

  $W_e$ ： 重み
]

$ a_t^i = phi (H_t^i; W_a) $
#text(size: 8pt)[
  $a_t^i$ ： 周囲状況を表す特徴ベクトル\

  $phi (H_t^i; W_a)$ ： 周囲情報を特徴ベクトルへ変換
]

$ h_t^i = "LSTM" (h_(t-1)^i, e_t^i, a_t^i; W_l) $
#text(size: 8pt)[
  $h_t^i$ ： i番目の人の更新した新しい hidden state

  $h_(t-1)^i$ ： 前回の hidden state\

  $e_t^i$ ： 自分の位置特徴ベクトル \

  $a_t^i$ ： 周囲状況を表す特徴ベクトル\
]

$ (hat(x), hat(y))_t^i ~ N(mu_t^i, sigma_t^i, rho_t^i) $
#text(size: 8pt)[
  $(hat(x), hat(y))_t^i$ ： 予測された未来位置\

  $N(mu_t^i, sigma_t^i, rho_t^i)$ ： 正規分布（ガウス分布）\

  $mu_t^i$ : 予測位置の中心\

  $sigma_t^i$ : 予測の広がり\

  $rho_t^i$ : x方向とy方向の関連
]

$ [mu_t^i, sigma_t^i, rho_t^i] = W_p h_(t-1)^i $
#text(size: 8pt)[
  $[mu_t^i, sigma_t^i, rho_t^i]$ : 未来位置分布の設定値\

  $h_(t-1)^i$ ： 前回の hidden state\

  $W_p$ ： 出力用の重み
]

#pagebreak()

$
  L^i (W_e, W_l, W_p) = - sum_(t=T_"obs"+1)^(T_"pred" )
  log(P(x_t^i, y_t^i | mu_t^i, sigma_t^i, rho_t^i))
$
#text(size: 8pt)[
  $L^i(W_e,W_l,W_p)$ ： 損失関数（Loss）\

  $W_e$ ： 自分位置embedding, $W_l$ ： LSTM内部, $W_p$ ： 出力変換\

  $-sum$ ： 未来時間全部の誤差を足す,\
  正解確率は大きいほどいいので$-$をつけてLossを最小化するようにしている

  $t=T_"obs"+1$ ： 観測終了後から, $T_"pred"$ ： 予測終了時刻

  $P(x_t^i, y_t^i | mu_t^i, sigma_t^i, rho_t^i)$ ： 本当の位置が予測分布でどれくらい確率高いか

  $-log(P)$ ： 予測が外れるほど大きくなる
]


== アプリ作成
- カラオケにあった「狩歌」というボードゲームが面白かったので、スマホでもできるように作成した
- ルール
  #align(center)[
    #image("takamiya20260529p6.png", width: 70%)
  ]
https://www.xaquinel.com/works/caruuta-basic-set

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0pt,

  box(width: 100%, clip: true, align(center, image("takamiya20260529p2.png", width: 85%))),
  box(width: 100%, clip: true, align(center, image("takamiya20260529p3.png", width: 85%))),
  box(width: 100%, clip: true, align(center, image("takamiya20260529p4.png", width: 85%))),
)
