#import "@preview/slydst:0.1.4": *
#import "@preview/codelst:2.0.2": sourcecode
#set text(font: "IPAexMincho", 9.6pt, weight: "black")
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
- --learning_rate 0.003: AIが学習する際の「歩幅」
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
- 実験ごとに ADE や FDE の数値をメモする
- 生成された plots/ フォルダの画像などの名前を変えて保存し直す
- 一から学習する場合は、model/ フォルダの中身を空にするか、別の場所に移動させてから train.py を動かす

== 今後の予定
- 現在のデータセットではなく、外部にあるデータセットを用いて実装する
- Yolo と接続して動画から人物の座標を取得し、取得した座標をもとにSocial-LSTMの実行を行う
