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
== Social-lstmの改良
- Social Gridの物理的な大きさが不明確
  - 従来のシステムでは画像座標を使用していた
  - 座標単位をピクセルからメートルに変換した
  -

- 現在作成しているCSVファイルを読み込めなかった
  - 従来のシステムではフレーム数、人物ID、x,y座標(ピクセル)を使用していた
  - 対象人物を中心として前後左右2m以内の人物をSocial Poolingへ反映するようにした

- モデルの実行結果内容が不十分だった
  - 従来のシステムでは人物の座標、IDしか出力されなかった
  - フレーム数、速度も見れるように追加した

- 軌跡の読み取り間隔が0.4秒間隔だった
  - 従来のシステムではモデルの切り取りが0.4秒間隔だった
  - 使用している現在の動画も0.4間隔に合わせた


== 動画データの追加
- 大学内の動画以外に撮影を行った
- 現在座標の整理中

= 今後の予定
- 他動画の座標変換
- Social-lstmの確認
