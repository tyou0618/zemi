#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)
#show "、": ", "
#show "。": ". "

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年7月10日",
)

== 今週行ったこと( 7/10 )
- データセットの変更
- 再理解
- 今後の予定

== データセットの変更
=== 変化前後の違い
#align()[ #text(10pt, "[変更前]") ]
- データセット: biwi_hotel のみ
- 平均
  - ADE(平均変位誤差):0.8752
  - FDE(最終変位誤差):1.6922

\

#align()[ #text(10pt, "[変更後]") ]
- データセット: \
  biwi_hotel, arxiepiskopi1, crowds_zara02, crowds_zara03, bookstore_0 \
- 平均
  - ADE(平均変位誤差):0.8375\
  - FDE(最終変位誤差):1.3816\

#pagebreak()

== 再理解
=== 論文の読み直し
Social-LSTMとYoLoの連携、およびデータセットの追加を行おうと考えていたが、思っていることができずAIに聞いてもわからなかったため一度論文の読み直しを行なっている\
前までは必要な箇所のみを翻訳していただけだったので抜けのないように改めて全文を目を通すようにしている

== 今後の予定
- データセットの変更
- Yolo 接続から座標取得
  - Pedestrian trajectory prediction method based on the Social-LSTM model for vehicle collision \
  https://academic.oup.com/tse/article/6/3/tdad044/7480246?utm_source=chatgpt.com&login=true
  - https://cvgl.stanford.edu/papers/CVPR16_Social_LSTM.pdf \
  https://cvgl.stanford.edu/papers/CVPR16_Social_LSTM.pdf
