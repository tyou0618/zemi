#import "@preview/codelst:2.0.2": sourcecode

#set text(font: "IPAexMincho", 12pt, weight: "black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em),
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)
#show "、": ", "
#show "。": ". "

#align(center)[
  #text(24pt, "リバーシ mian.dart について")
]
= プログラム概要
main.dartは、本システムのユーザーインターフェースを管理するプログラムである。\
Flutterを用いてゲーム画面を構築し、リバーシ盤面の表示やプレイヤーの操作受付を行う。\
また、現在の手番やスコア、ゲーム結果などの情報を表示するとともに、ゲームモードの切り替えやリセット機能などを担当している。\
さらに、AI対戦時にはAIの思考開始タイミングを制御し、思考中の操作制限を行うことで、円滑なゲーム進行を実現している。\
logic.dartで実装されたゲームロジックと連携し、ゲームの進行状況に応じて画面表示を更新する役割も担う。


= プログラム内容(抜粋)
== AI着手制御機能
プレイヤーの着手後に現在の手番を判定し、AIの手番である場合は自動的にAIの着手処理を実行する機能である。

AIの難易度に応じて異なる着手アルゴリズムを呼び出し、選択された手をゲームロジックへ反映する。また、AI思考中はユーザー操作を無効化することで誤操作を防止している。\
[解説]\
- 3行目:現在の手番がAIであるかを判定し、人間の手番では処理を実行しない。

#sourcecode[```dart
  void _triggerAiMoveIfNeeded() async {
    if (_game.gameMode != 0 && !_game.isGameOver()) {
      if (_game.currentPlayer != _game.aiPlayer) return;
      setState(() {
        _isAiThinking = true;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        List<int>? aiMove;

        if (_game.gameMode == 1) {
          aiMove = _game.getWeakAiMove();

        } else if (_game.gameMode == 2) {
          aiMove = _game.getStrongAiMove();

        } else if (_game.gameMode == 3) {
          aiMove = _game.getExpertAiMove();
        }

        if (aiMove != null) {
          _game.playTurn(
            aiMove[0],
            aiMove[1],
          );
        }

        setState(() {
          _isAiThinking = false;
        });
        _triggerAiMoveIfNeeded();
      });
    }
  }
```]




#sourcecode[```dart
  @override
  Widget build(BuildContext context) {
    // 現在の手番に応じて背景色を変更
    final Color backgroundColor = _game.currentPlayer == 1
        ? Colors
              .green
              .shade50 // 黒の手番
        : Colors.blue.shade50; // 白の手番

    return Scaffold(
      // アプリ上部のヘッダー
      appBar: AppBar(
        title: const Text('リバーシ'), // タイトル表示
        centerTitle: true, // タイトルを中央揃え
        backgroundColor: Colors.transparent, // 背景透明
      ),

      // 背景色をアニメーション付きで変更
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // アニメーション時間
        curve: Curves.easeInOut, // 緩やかな変化
        color: backgroundColor, // 手番に応じた背景色
        // スマートフォンのノッチ等と重ならない領域
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12), // 上部余白

              _buildScoreBoard(), // スコア・操作パネル表示

              const SizedBox(height: 12), // 間隔

              Expanded(child: Center(child: _buildBoard())),
            ],
          ),
        ),
      ),
    );
  }

  // スコアボードおよびゲーム状態表示エリアを生成
  Widget _buildScoreBoard() {
    // 現在の手番に応じて石の色を決定
    final Color turnColor = _game.currentPlayer == 1
        ? Colors.black
        : Colors.white;

    // 現在の手番プレイヤー名を表示するテキスト
    String turnText = _game.currentPlayer == 1
        ? "${_game.blackPlayerName}（黒）の番"
        : "${_game.whitePlayerName}（白）の番";

    // AI思考中は専用メッセージを表示
    if (_isAiThinking) {
      turnText = "AI思考中...";
    }

    // ゲーム終了判定
    final bool isOver = _game.isGameOver();

    // 黒石の数を取得
    int black = _game.countStones(1);

    // 白石の数を取得
    int white = _game.countStones(2);

    // 石数を比較して勝敗メッセージを決定
    String resultText = black > white
        ? "🎉 黒の勝利！"
        : white > black
        ? "🎉 白の勝利！"
        : "🤝 引き分け！";

    // 勝者に応じて結果表示エリアの背景色を変更
    Color winnerContainerColor = black > white
        ? Colors.black
        : white > black
        ? Colors.white
        : Colors.grey.shade300;

    // 勝敗表示の文字色を設定
    Color winnerTextColor = (black > white) ? Colors.white : Colors.black;

    return Column(
      children: [
        // 手番表示と勝敗表示を行うエリア
        AnimatedContainer(
          duration: const Duration(milliseconds: 300), // 表示切替時のアニメーション時間
          // ゲーム中と終了時で余白サイズを変更
          padding: EdgeInsets.symmetric(
            horizontal: isOver ? 32 : 24,
            vertical: isOver ? 14 : 8,
          ),

          decoration: BoxDecoration(
            // ゲーム終了時は勝者色、通常時は半透明の白背景
            color: isOver
                ? winnerContainerColor
                : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(30), // 角を丸くする
            boxShadow: // ゲーム終了時は影を強調
            isOver
                ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10, // 影のぼかし量
                      offset: const Offset(0, 4), // 影の位置
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),

          // 横方向に要素を配置
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ゲーム進行中のみ現在の手番の石を表示
              if (!isOver) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200), // 石の切替アニメーション

                  width: 24, // 石の幅
                  height: 24, // 石の高さ

                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // 円形

                    color: turnColor, // 黒番なら黒、白番なら白

                    border: Border.all(
                      // 白石の場合のみ外枠を表示
                      color: _game.currentPlayer == 1
                          ? Colors.transparent
                          : Colors.black26,

                      width: 2,
                    ),
                  ),
                ),

                const SizedBox(width: 12), // 石と文字の間隔
              ],

              // 手番または勝敗結果を表示
              Text(
                // ゲーム中は現在の手番、終了時は勝敗結果を表示
                isOver ? resultText : turnText,

                style: TextStyle(
                  // 終了時は文字サイズを大きくして強調
                  fontSize: isOver ? 22 : 18,

                  fontWeight: FontWeight.bold, // 太字
                  // 勝敗表示時は背景色に応じて文字色を変更
                  color: isOver ? winnerTextColor : Colors.black,
                ),
              ),
            ],
          ),
        ),

        // パス発生時のメッセージを表示
        // ゲーム終了後は表示しない
        if (_game.passMessage.isNotEmpty && !isOver)
          Padding(
            // 上方向に少し余白を追加
            padding: const EdgeInsets.only(top: 4),

            child: Text(
              // 「黒は置けないためパス」などを表示
              _game.passMessage,

              style: const TextStyle(
                color: Colors.red, // 注意表示のため赤色
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        const SizedBox(height: 8), // 間隔
        // 黒石と白石の数を表示するエリア
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // 黒石数表示
            _buildSmallScoreBadge(player: 1, count: black),

            const SizedBox(width: 20),

            // 白石数表示
            _buildSmallScoreBadge(player: 2, count: white),
          ],
        ),

        const SizedBox(height: 12), // 間隔
        // 操作パネル
        // 戻るボタン・リセットボタン・ゲームモード切替を配置
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: Wrap(
            // ボタン同士の間隔
            spacing: 8,
            runSpacing: 8,

            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,

            children: [
              // 解説ページへ戻るボタン
              IconButton(
                onPressed: () async {
                  // 解説ページのURLを生成
                  final Uri url = Uri.parse(
                    'https://www.oit.ac.jp/labs/rd/rssrv/kobayashi-lab/~takamiya/flutter/reversi.html',
                  );

                  // URLが開ける場合のみブラウザ起動
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },

                icon: const Icon(Icons.logout), // 戻るアイコン
                tooltip: '解説ページへ戻る',
              ),

              // ゲームリセットボタン
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    // ゲーム状態を初期化
                    _game.reset();

                    // AI思考状態も解除
                    _isAiThinking = false;
                  });

                  // AI戦の場合は初手AIを実行
                  _triggerAiMoveIfNeeded();
                },

                icon: const Icon(Icons.refresh), // リセットアイコン
                label: const Text("リセット"),
              ),

              // ゲームモード切替ボタン群
              ToggleButtons(
                // 現在選択中のモードを表示
                isSelected: [
                  _game.gameMode == 0, // 二人対戦
                  _game.gameMode == 1, // AI弱
                  _game.gameMode == 2, // AI強
                  _game.gameMode == 3, // AI最強
                ],

                // ボタン押下時の処理
                onPressed: (int index) {
                  setState(() {
                    // 選択されたモードに変更
                    _game.gameMode = index;

                    // 新しいモードでゲーム開始
                    _game.reset();

                    _isAiThinking = false;
                  });

                  // AI戦の場合はAI着手判定
                  _triggerAiMoveIfNeeded();
                },

                borderRadius: BorderRadius.circular(20), // ボタン角丸

                constraints: const BoxConstraints(minHeight: 36, minWidth: 68),

                selectedColor: Colors.white, // 選択時文字色

                fillColor: Colors.green.shade700, // 選択時背景色

                children: const [
                  // 人対人モード
                  Text(
                    "二人対戦",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),

                  // ランダムAI
                  Text(
                    "AI（弱）",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),

                  // 重み付けAI
                  Text(
                    "AI（強）",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),

                  // 探索AI
                  Text(
                    "AI（最強）",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 石の色と個数を表示するスコアバッジを生成
  Widget _buildSmallScoreBadge({required int player, required int count}) {
    return Row(
      children: [
        // 石を表す円
        Container(
          width: 16,
          height: 16,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            // プレイヤーに応じて石の色を変更
            color: player == 1 ? Colors.black : Colors.white,

            border: Border.all(color: Colors.black38, width: 1),
          ),
        ),

        const SizedBox(width: 6), // 石と個数表示の間隔
        // 石の個数を表示
        Text(
          "$count個",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // リバーシ盤面を生成
  Widget _buildBoard() {
    return Padding(
      // 盤面の外側余白
      padding: const EdgeInsets.all(16.0),

      child: AspectRatio(
        // 常に正方形の盤面を維持
        aspectRatio: 1,

        child: Container(
          // 盤面全体の外枠
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),

          // 8×8のマスを生成
          child: GridView.builder(
            // スクロールを無効化
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // 8列構成
              crossAxisCount: 8,
            ),

            itemCount: 64, // 8×8=64マス

            itemBuilder: (context, index) {
              // 1次元インデックスを行番号へ変換
              int row = index ~/ 8;

              // 1次元インデックスを列番号へ変換
              int col = index % 8;

              // 現在マスの状態取得
              // 0:空き 1:黒 2:白
              int stoneState = _game.board[row][col];

              return GestureDetector(
                // マスがタップされた時の処理
                onTap: () {
                  // AI思考中または石が存在する場合は無効
                  if (_isAiThinking || stoneState != 0) {
                    return;
                  }

                  // 石を置けた場合
                  if (_game.playTurn(row, col)) {
                    // 画面更新
                    setState(() {});

                    // AI対戦時はAI着手判定
                    _triggerAiMoveIfNeeded();
                  }
                },

                child: Container(
                  // マスの見た目設定
                  decoration: BoxDecoration(
                    // リバーシ盤面の緑色
                    color: const Color(0xff0f7d32),

                    // マスの境界線
                    border: Border.all(color: Colors.black54, width: 0.5),
                  ),

                  child: Stack(
                    alignment: Alignment.center,

                    children: [
                      // 石の描画
                      ReversiStone(state: stoneState),

                      // 合法手の場所に黄色マーカーを表示
                      if (stoneState == 0 &&
                          _game.canPlaceStone(row, col, _game.currentPlayer))
                        const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.yellow,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// リバーシの石を描画するウィジェット
class ReversiStone extends StatelessWidget {
  // 石の状態 0:空きマス 1:黒石 2:白石
  final int state;
  const ReversiStone({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state == 0) return const SizedBox(); // 空きマスの場合は何も表示しない

    final double turns = state == 1 ? 0.0 : 0.5; // 黒石なら0回転、白石なら180度回転

    return FractionallySizedBox(
      // マスの85%のサイズで石を描画
      widthFactor: 0.85,
      heightFactor: 0.85,

      child: AnimatedRotation(
        // 石の状態に応じて回転
        turns: turns,

        // 回転アニメーション時間
        duration: const Duration(milliseconds: 300),

        // 滑らかな回転を実現
        curve: Curves.easeInOut,

        child: Stack(
          children: [
            // 白石の描画
            // 裏面として利用
            Transform.flip(
              // 上下反転
              flipY: true,

              child: _buildStoneContainer(
                colors: [Colors.white, const Color(0xffdddddd)],
                isBlack: false,
              ),
            ),

            // 黒石の描画
            // stateに応じて表示・非表示を切替
            Opacity(
              // 黒石なら表示、白石なら非表示
              opacity: state == 1 ? 1.0 : 0.0,

              child: _buildStoneContainer(
                colors: [const Color(0xff555555), Colors.black],
                isBlack: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 石本体の見た目を生成する関数
  Widget _buildStoneContainer({
    required List<Color> colors,
    required bool isBlack,
  }) {
    return Container(
      decoration: BoxDecoration(
        // 円形の石を生成
        shape: BoxShape.circle,

        // 立体感を出すための影
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(2, 2)),
        ],

        // グラデーションによる光沢表現
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}


```]
