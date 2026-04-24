#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font:"Noto Serif JP",10pt,weight:"black")
#set par(first-line-indent:(amount:1em,all: true),justify: true)

#show: slides.with(
  title:"全体ゼミでの振り返り",)

== 今週行ったこと( 4/17 )
- Mac mini の設定続き
- 類似研究の論文調査
- Yoloについて

== Mac mini の設定続き
- VScodeとgit hub の連携
  - 論文や発表資料を私用パソコンと連携
  - それとは別に研究等で使用するファイルを作成した
\
- ロジクールのマウスを設定
  - サイドボタンを使う状況に合わせてコマンドやショートカットキーを使えるようにした
\

== 類似研究の論文調査
=== 全天球カメラを用いたリアルタイム行列検知
全天球カメラのパノラマ映像を活用して、現実空間の行列をリアルタイムで検知する研究.
#align(center)[
    #image("takamiya20260424p2.png", width: 62%)
]
- https://pmc.ncbi.nlm.nih.gov/articles/PMC11207467/
(2024)


全方位を記録できるカメラ特有の歪みを解消するため、座標系を変換して人物の向きをベクトル化し、その一致度から行列かどうかを判定
\
\

人を検知するのは物体検出アルゴリズムのYOLOv4、
\ 各個人の視線や体の向きを推定する技術は骨格検出技術のOpenPose
\

向きの直線度合いで列ができているかどうかを検知、測定
\

実験では、直線状に並ぶ人群に対して高い評価指数を記録し、円状の集まりと明確に区別できることが示されていた
\


== Yoloについて
YOLO (You Only Look Once)
\