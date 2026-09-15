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
- Yolo と ByteTrack を組み合わせて人物を検知、追跡することができるようになった
  - Yolo v11n を使用した
  - ByteTrack はGitHubからソースコードを取得して使用した

- １人称視点の映像を使用しようとしていたが、人物の検知・追跡がうまくいかず映像を変更した
  - 変更後の映像は、上から撮られた固定カメラ映像
  - ホモグラフィー変換が使用できるように、既に行列が作成されているデータセットを使用している

- 使用している映像のホモグラフィー変換が正常に行われるように修正中
  - 軌跡を描画するだけならピクセル座標のままでも問題ないが、Social-LSTMを使うとなるとホモグラフィー変換を行い現実空間座標に変換する必要がある


#align(center)[
  #image("takamiya20260911p1.png", width: 70%)
]
= 今後の予定
- ホモグラフィー変換の修正
- 既存のSocial-LSTMのコードを導入、使用できるようにする
- 予測結果の可視化
