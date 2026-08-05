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
- 今週8月6日、7日がワークショップ
  - 内容の最終調整と原稿の作成、資料の印刷
  - Air draw ,Air code は今回は見送り


= 今後の予定
カメラ映像[映像入力] → OpenCV[フレーム取得] → \
Yolo v11n(v8n)[人物取得]  → ByteTrack[人物追跡・ID] → \
OpenCV / NumPy[足元中心座標を取得] → (Homography[画像座標 → 地面座標]) →\
→ Social-LSTM[将来軌跡予測] +新規性:心理バイアス
\
