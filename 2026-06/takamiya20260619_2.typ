#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.4pt, weight: "black")
#set par(justify: true)

#show: slides.with(
  title: "全体ゼミでの振り返り",
  authors: "923044 高宮悠聖",
  date: "2026年6月19日",
)

== 今週行ったこと( 6/19 )
- Social-LSTMの複数回実行
- 今後の予定

== Social-LSTMの複数回実行
=== 実行手順
1. プロジェクトディレクトリに移動

2. Python仮想環境を起動する \
  [ source venv/bin/activate ]

3. モデルの学習 \
python train.py: 学習メイン処理を起動する \
[ python train.py --num_epochs 30 --batch_size 5 --learning_rate 0.003 ]
- python train.py: 学習メイン処理を起動
- --num_epochs 30: データを何周させて重みを鍛えるか
- --batch_size 5: 1回のパラメータ更新で同時に計算するシーケンスの数
- --learning_rate 0.003: 予測間違いを修正するときどれだけパラメータを動かすか
結果の確認方法:ターミナルにログが表示される

#pagebreak()

4. 未知の未来の予測テスト \
[ python test.py --epoch 29 --obs_length 8 --pred_length 12 --method 1 ]
- python test.py: テスト処理を起動
- --epoch 29: train.pyで保存された中から、29番目のエポック重みを指定してロード
- --obs_length 8: 最初の8フレーム分を過去に目撃したデータとしてAIに入力
- --pred_length 12: 続く12フレーム分の未来の軌跡をAIに完全自動予測する
- --method 1: 予測モデルの種類としてSocial-LSTMを指定する
結果の確認方法:
- ターミナルに数値成績が表示される
- result/SOCIALLSTM/ に予測された座標が記録されたテキストファイル（.txt）が出力される
- plot/SOCIALLSTM/LSTM/test/ に、次の可視化ステップに引き渡すための予測データ（.pkl）が生成される

#pagebreak()

5. 予測結果のグラフ画像・動画化
[ python visualize.py --num_of_data 5 --method 1 ]
- python visualize.py: 可視化スクリプトを起動
- --num_of_data 5: test.pyの予測結果から、ランダムに5つ選んでビジュアル化する
- --method 1: 対象モデルとして「Social-LSTM」を指定する
結果の確認方法:
- plot/SOCIALLSTM/LSTM/plots/ に正解の線とAIの予測線が描かれたPNG画像（.png）が生成される
- plot/SOCIALLSTM/LSTM/videos/ に歩行者の動きを再現したMP4動画（.mp4）が自動生成される

6. 結果のバックアップ
- 実験ごとに ADE(平均変位誤差) や FDE(最終変位誤差) の数値をメモする
- 生成された plots/ フォルダの画像などの名前を変えて保存し直す
- 一から学習する場合は、model/ フォルダの中身を空にするか、別の場所に移動させてから train.py を動かす

== 実験結果
=== epochs 30 batch_size 5 learning_rate 0.003 の場合
[epoch 29] \
valid_loss = 1.636, \
valid_mean_err = 0.882, \
valid_final_err = 1.776 \
Best epoch 12 \
Best valid_loss = 1.273 \
Best valid_mean_err = 0.886 \
Best valid_final_err = 1.699

=== epochs 15 batch_size 5 learning_rate 0.003 の場合
(epoch 14), valid_loss = 3.407, valid_mean_err = 0.910, valid_final_err = 1.848
Best epoch 3 Best validation loss 2.5164728303921637 Best error epoch 13 Best error tensor(1.3599)
Saving model
Best epoch 0 Best validation Loss 100 Best error epoch 0 Best error 100000
Best epoch acording to validation dataset 3 Best validation Loss 2.5164728303921637 Best error epoch 13 Best error tensor(1.3599)
(epoch 3), valid_loss = 2.516, valid_mean_err = 1.014, valid_final_err = 2.057
Best epoch 3 Best validation loss 2.5164728303921637 Best error epoch 3 Best error tensor(1.5358)
Saving model

=== epochs 30 batch_size 5 learning_rate 0.0015 の場合
(epoch 29), valid_loss = 1.735, valid_mean_err = 0.899, valid_final_err = 1.843
Best epoch 14 Best validation loss 1.4595609503075604 Best error epoch 27 Best error tensor(1.3396)
Saving model
Best epoch 0 Best validation Loss 100 Best error epoch 0 Best error 100000
Best epoch acording to validation dataset 14 Best validation Loss 1.4595609503075604 Best error epoch 27 Best error tensor(1.3396)
(epoch 14), valid_loss = 1.460, valid_mean_err = 0.918, valid_final_err = 1.849
Best epoch 14 Best validation loss 1.4595609503075604 Best error epoch 13 Best error tensor(1.3528)
Saving model

=== epochs 15 batch_size 5 learning_rate 0.0015 の場合
(epoch 14), valid_loss = 1.681, valid_mean_err = 0.871, valid_final_err = 1.709
Best epoch 7 Best validation loss 1.6065103109861756 Best error epoch 14 Best error tensor(1.2901)
Saving model
Best epoch 0 Best validation Loss 100 Best error epoch 0 Best error 100000
Best epoch acording to validation dataset 7 Best validation Loss 1.6065103109861756 Best error epoch 14 Best error tensor(1.2901)
(epoch 7), valid_loss = 1.607, valid_mean_err = 0.933, valid_final_err = 1.885
Best epoch 7 Best validation loss 1.6065103109861756 Best error epoch 7 Best error tensor(1.4091)
Saving model

== 今後の予定
- 現在のデータセットではなく、外部にあるデータセットを用いて実装する
- Yolo と接続して動画から人物の座標を取得し、取得した座標をもとにSocial-LSTMの実行を行う
