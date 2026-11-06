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
== 倫理申請書の完成
- 提出期限ギリギリになったがなんとか新規申請書と説明書を完成させた
- 申請書に記述した実験はシステムのプロトタイプが出来次第行う予定

== ホモグラフィ変換の修正
- 作成自体はできていたが誤差が大きかったり少しずつずれたりが多かった
- 改めて計測を行い、数値の訂正、点の増加を行った
- 最大誤差は増えたが、平均誤差は減った
- 右側と奥行きに変換可能領域が増えたことでより詳細な歩行者軌跡を計測できるようになった

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,

    [#image("takamiya20261106p1.png", height: 130pt)#text(12pt, "修正前")],
    [#image("takamiya20261106p2.png", height: 130pt)#text(12pt, "修正後")],
  )
]


ここまでで、h12動画について「追跡範囲の改善 → Homography変換 → 異常確認 → Social-LSTM前処理 → 予測」まで進みました。
1. 歩行可能領域のポリゴンを適用
CVATで作成したポリゴンを使い、人物の足元が歩行可能領域内にある場合だけYOLO検出をByteTrackへ渡すようにしました。
最初に使用したポリゴン：
[h1_walkable_floor.xml](/Users/takamiya/pp/data/umeda/hnk/h1/h1_walkable_floor.xml)
その後、画面奥の信頼性が低い領域を狭めた新しいポリゴンを作成しました。
[h1_walkable_floor2.xml](/Users/takamiya/pp/data/umeda/hnk/h1/h1_walkable_floor2.xml)
現在は標準名のh1_walkable_floor.xmlにも新しい内容を反映しています。
ポリゴンは2領域あります。
- 中央から左側の主要な歩行領域
- 右端の歩行領域
新しいポリゴンを使ったh12の追跡結果：
[generic/h12/20261106_151054_409579](/Users/takamiya/pp/data/output/generic/h12/20261106_151054_409579)
出力内容：
- tracking_result.mp4：YOLO・ByteTrack・ポリゴンの確認動画
- tracking_pixels.csv：足元ピクセル座標
- track_summary.csv：IDごとの追跡結果
- excluded_detections.csv：ポリゴン外として除外した検出
- region.xml：実行時に使用したポリゴン
- run.json：実行条件と集計結果
新ポリゴン適用後の結果：
内容	結果
YOLO検出	45,182
ポリゴン内で採用	21,385
ポリゴン外として除外	23,797
ByteTrackの座標数	20,318
ID数	137


旧ポリゴンと比較すると、正常な座標をほぼ維持したまま、画面奥の信頼性が低い検出を減らせました。
2. Homography変換
追跡結果の足元ピクセル座標を、実世界のメートル座標へ変換しました。
使用した行列：
[H.txt](/Users/takamiya/pp/data/umeda/hnk/h1/h11_calibration_20261104_115111/homography/H.txt)
変換対象：
[tracking_pixels.csv](/Users/takamiya/pp/data/output/generic/h12/20261106_151054_409579/tracking_pixels.csv)
変換結果：
[homography/h12/20261106_151306_067706](/Users/takamiya/pp/data/output/homography/h12/20261106_151306_067706)
主な出力：
- tracking_world.csv：ピクセル座標とメートル座標
- trajectories_world.png：全軌跡の平面図
- homography_grid.png：元画像にメートル格子を重ねた画像
- homography_metadata.json：動画、行列、座標範囲などの条件
- homography_summary.json：変換件数と品質フラグ
- homography.txt：使用した行列のコピー
20,318点すべてをメートル座標へ変換できました。
座標範囲は次のようになりました。
X：-3.51 ～ 19.14 m
Y：-4.07 ～ 27.24 m
trajectories_world.pngの軸は、現在次の配置に戻しています。
- 横軸：世界座標X
- 縦軸：世界座標Y
[trajectories_world.png](/Users/takamiya/pp/data/output/homography/h12/20261106_151306_067706/trajectories_world.png)
3. 品質フラグの整理
tracking_world.csvには、主に次の情報があります。
world_valid
Homography変換を数値的に実行できたかを示します。
- 1：変換できた
- 0：変換できなかった
今回のh12は全点が1でした。
boundary_flag
人物の検出枠が映像端に接しているかを示します。
- 1：映像端に接している
- 0：接していない
これはメートル座標範囲外を表すフラグではありません。
speed_flag
連続するフレーム間で計算した速度が3 m/sを超えたかを示します。
- 1：3 m/sを超えた
- 0：3 m/s以下、または速度を計算できない
新ポリゴン適用後では4,368点、全体の約21.5%に速度フラグが付きました。
ただし約60 fpsのフレーム間速度なので、足元位置のわずかな揺れでも大きな速度になりやすくなっています。
4. メートル座標の確認動画を作成
tracking_world.csvの内容を元動画上で確認できるプログラムを追加しました。
[visualize_world_tracking.py](/Users/takamiya/pp/src/visualize_world_tracking.py)
生成した動画：
[tracking_world_review.mp4](/Users/takamiya/pp/data/output/homography/h12/20261106_151306_067706/tracking_world_review.mp4)
動画内の色：
- 緑：正常
- 黄：検出枠が映像端に接している
- 橙：速度が3 m/sを超えている
- 赤：指定した世界座標範囲外
各人物には次を表示しています。
- ID
- X座標
- Y座標
- 瞬間速度
- 直近の足元軌跡
確認の結果、画面手前の人物はY座標が負になり、赤く表示されることが分かりました。実験では画面手前を使用しない方針にしました。
5. Social-LSTM用の有効範囲を設定
Social-LSTMに使用する範囲を次のように設定しました。
X：-0.25 ～ 17.85 m
Y：-0.25 ～ 26.35 m
この範囲外は、前処理で次のように記録されます。
included = 0
excluded_reason = world_bounds
世界座標範囲による除外処理は、次のファイルに追加しました。
[preprocessing.py (line 41)](/Users/takamiya/pp/src/social_lstm/new/preprocessing.py:41)
実行時に範囲を指定できるよう、--world-boundsも追加しました。
6. Social-LSTM前処理
h12のtracking_world.csvをSocial-LSTM用に前処理しました。
前処理結果：
[preprocessing/h12/20261106_153816_473926](/Users/takamiya/pp/data/output/social_lstm/preprocessing/h12/20261106_153816_473926)
前処理では次を行いました。
1. Homography変換できなかった点を除外
2. 映像端に接する点を除外
3. 世界座標範囲外を除外
4. 時間的に途切れた軌跡を分割
5. 9点の移動中央値で平滑化
6. 約60 fpsの軌跡を0.4秒間隔へ変換
7. Social-LSTM用の連続系列を作成
結果：
内容	件数
入力座標	20,318
採用	14,018
除外	6,300
世界座標範囲外	5,709
映像端	591
0.4秒間隔への変換後	574
対象ID	66
軌跡区間	106
過去8点を作れる系列	181
過去8点＋未来12点が揃う系列	16


出力ファイル：
- trajectory_raw.csv：除外理由を含む元データ
- trajectory_smoothed.csv：平滑化した軌跡
- trajectory_resampled.csv：0.4秒間隔へ揃えた軌跡
- trajectory_comparison.png：処理前後の比較
- preprocessing_summary.json：前処理結果
7. h12でSocial-LSTM予測を実行
前処理済みデータを、学習済みモデルへ入力しました。
使用モデル：
[model_best.pt](/Users/takamiya/pp/models/social_lstm_metric/formal_20261009/model_best.pt)
予測結果：
[prediction/20261106_154327_887038](/Users/takamiya/pp/data/output/social_lstm/prediction/20261106_154327_887038)
出力：
- predictions.csv：観測・予測・正解座標
- prediction_plot.png：観測・予測・正解の比較
- prediction_summary.json：使用条件と結果
- evaluation_summary.json：ADE・FDE
今回の結果：
内容	結果
予測対象	8人
正解と照合できた未来点	65点
ADE	1.025 m
FDE	1.675 m


人物によって結果に差があります。
- ID 11・12など：比較的良好
- ID 4・6・7：将来方向がずれ、FDEが3～4m
- 一部の人物：未来12点が揃わず、2～11点だけで評価
したがって、Social-LSTMの接続と予測には成功していますが、この1回の結果だけでは正式な精度評価になりません。
次に行うこと
次は、未来12点まで揃っている16系列をすべて評価します。
1. Social-LSTMの全系列評価
.venv/bin/python -m src.social_lstm.new.cli evaluate-dataset \
data/output/social_lstm/preprocessing/h12/20261106_153816_473926/trajectory_resampled.csv \
models/social_lstm_metric/formal_20261009/model_best.pt \
--output data/output/social_lstm/evaluation/h12_social_lstm
これにより、同じ条件の全系列についてADE・FDEが計算されます。
2. 等速直線予測との比較
Social-LSTMの評価が完了したら、同じデータを等速直線予測でも評価します。
.venv/bin/python tests/evaluate_constant_velocity.py \
data/output/social_lstm/preprocessing/h12/20261106_153816_473926/trajectory_resampled.csv \
--output data/output/social_lstm/evaluation/h12_constant_velocity \
--social-lstm-summary data/output/social_lstm/evaluation/h12_social_lstm/evaluation_summary.json
ここで比較する指標は次の2つです。
- ADE：予測期間全体の平均誤差
- FDE：12点目、4.8秒後の最終誤差
Social-LSTMのADE・FDEが等速直線予測より小さければ、周囲の歩行者を考慮するモデルの効果が出ている可能性があります。大きければ、学習データとh12の環境差、追跡誤差、軌跡の平滑化、モデル学習方法を見直します。
直近の作業は、1つ目のコマンドでh12の16系列を一括評価することです。



= 今後の予定
-


