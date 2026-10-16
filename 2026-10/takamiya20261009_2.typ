#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年10月09日",
)

== 今週行ったこと( 10/9 )
- ホモグラフィ変換の実装
- social-lstm前までの動作確認
- 今後の予定



== ホモグラフィ変換の実装
- 合計25点を計算用と検証用の2種類の点に分けた
  - 計算用 10点 検証用 15点

- 検証平均誤差：約2.54cm  最大誤差：約5.42cm


#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261009p1.png", height: 100pt)], [#image("takamiya20261009p2.png", height: 100pt)],
  )
]


== social-lstm前までの動作確認
=== 成功点
- u2(一人だけの動画)とu4(複数人が写っている動画)の人物追跡を行った
- どちらも問題なくID維持まで実行できていた
- Homography変換による座標変換も100%成功していた
=== 問題点
- u4では数フレームだけ出現するIDや一時的な追跡切れが確認された
- 速度が3m/sを超える点が複数存在した
  - 主な原因は人物検出枠の下端の揺れ → 平滑化

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261009p4.png", height: 102pt)], [#image("takamiya20261009p3.png", height: 100pt)],
  )
]


== 今後の予定
- Social-LSTMの実装
- 新しいデータの撮影
