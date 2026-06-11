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
  #text(24pt, "リバーシ コード全体")
]

= main.dart
#sourcecode[```dart

// main.dart
import 'package:flutter/material.dart'; // FlutterのUI機能を利用するためのライブラリ
import 'logic.dart'; // リバーシのゲームロジックを定義したファイル
import 'package:url_launcher/url_launcher.dart'; // 外部ブラウザでWebページを開くためのライブラリ

// アプリケーションの開始地点
void main() {
  runApp(const MyApp()); // MyAppウィジェットを起動
}

// アプリ全体を管理するクラス
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reversi', // アプリ名
      // アプリ全体のテーマ設定
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green, // メインカラーを緑に設定
        ),
        useMaterial3: true, // Material Design 3を使用
      ),

      home: const ReversiPage(), // 起動時に表示する画面
    );
  }
}

// リバーシ画面を表すStatefulWidget
// ゲームの進行に応じて画面を更新するためStatefulWidgetを使用
class ReversiPage extends StatefulWidget {
  const ReversiPage({super.key});

  @override
  State<ReversiPage> createState() => _ReversiPageState(); // 状態管理クラスを生成
}

// ReversiPageの状態管理クラス
class _ReversiPageState extends State<ReversiPage> {
  final ReversiGame _game = ReversiGame(); // リバーシのゲームロジックを管理するオブジェクト

  bool _isAiThinking = false; // AI思考中かどうかを管理するフラグ

  // AIの手番になった際に自動で着手を行う関数
  void _triggerAiMoveIfNeeded() async {
    // AI対戦モード中かつゲームが終了していない場合のみ実行
    if (_game.gameMode != 0 && !_game.isGameOver()) {
      // 現在の手番がAIでなければ処理終了
      if (_game.currentPlayer != _game.aiPlayer) return;

      setState(() {
        _isAiThinking = true; // AI思考中状態にする
      });

      // AIの思考演出として1秒待機
      Future.delayed(const Duration(milliseconds: 1000), () {
        // ウィジェットが破棄されていた場合は処理終了
        if (!mounted) return;

        List<int>? aiMove; // AIが選択した手を保存

        // 弱AI
        if (_game.gameMode == 1) {
          aiMove = _game.getWeakAiMove();

          // 強AI
        } else if (_game.gameMode == 2) {
          aiMove = _game.getStrongAiMove();

          // 最強AI
        } else if (_game.gameMode == 3) {
          aiMove = _game.getExpertAiMove();
        }

        // AIが有効な手を選択した場合
        if (aiMove != null) {
          _game.playTurn(
            aiMove[0], // 行番号
            aiMove[1], // 列番号
          );
        }

        setState(() {
          _isAiThinking = false; // 思考終了
        });

        // パスなどでAIの手番が続く場合に再度実行
        _triggerAiMoveIfNeeded();
      });
    }
  }

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

#pagebreak()

= logic.dart
#sourcecode[```dart

import 'dart:math'; // 数学関数や乱数生成機能を利用するためのライブラリ

/// 置換表(Transposition Table)に保存するデータ構造
class TTEntry {
  final int hash; // 盤面のハッシュ値
  final int score; // その盤面の評価値
  final int depth; // 探索した深さ
  final int flag; // 評価値の種類 0:正確値 1:下限値(Betaカット) 2:上限値
  final List<int>? bestMove; // その盤面で最善と判断された手
  // コンストラクタ
  TTEntry({
    required this.hash,
    required this.score,
    required this.depth,
    required this.flag,
    this.bestMove,
  });
}

// リバーシゲーム全体を管理するクラス
class ReversiGame {
  late List<List<int>> board; // 盤面情報 0:空き 1:黒 2:白
  int currentPlayer = 1; // 現在の手番 1=黒, 2=白
  String passMessage = ""; // パス発生時の表示メッセージ
  int gameMode = 0; // 0:二人対戦 1:弱AI 2:強AI 3:最強AI
  int aiPlayer = 2; // AIが担当するプレイヤー番号

  // 黒プレイヤー名を取得
  String get blackPlayerName =>
      gameMode == 0 ? "プレイヤー1" : (aiPlayer == 1 ? "AI" : "あなた");

  // 白プレイヤー名を取得
  String get whitePlayerName =>
      gameMode == 0 ? "プレイヤー2" : (aiPlayer == 2 ? "AI" : "あなた");

  // 8方向探索用ベクトル
  final List<List<int>> _directions = [
    [-1, -1], // 左上
    [-1, 0], // 上
    [-1, 1], // 右上
    [0, -1], // 左
    [0, 1], // 右
    [1, -1], // 左下
    [1, 0], // 下
    [1, 1], // 右下
  ];

  final Map<int, TTEntry> _transpositionTable = {}; // 置換表 同じ盤面の再探索を防ぐために使用
  late List<List<int>> _zobristTable; // Zobrist Hash用乱数テーブル [64マス][空き・黒・白]
  int _zobristPlayerXor = 0; // 手番情報をハッシュへ反映するためのXOR値
  int _currentHash = 0; // 現在盤面のハッシュ値

  // Killer Heuristic用テーブル [探索深さ][最大2手]
  late List<List<List<int>?>> _killerMoves;
  late List<List<int>> _historyTable; // History Heuristic用テーブル 各手の有効度を保存

  // Edge+2 Pattern Evaluation用評価テーブル 3^10 = 59049通りのパターンを保存
  static final List<int> _edgePatternTable = List.filled(59049, 0);
  static bool _patternTableInitialized = false; // 評価テーブル初期化済み判定

  // コンストラクタ
  ReversiGame() {
    _initZobrist(); // Zobrist Hashテーブル生成
    _initPatternTable(); // パターン評価テーブル生成
    reset(); // ゲーム初期化
  }

  // Zobrist Hash用の乱数テーブルを生成
  void _initZobrist() {
    final rand = Random(42); // 再現性を確保するため固定シードを使用

    // 64マス × 3状態(空・黒・白)の乱数を生成
    _zobristTable = List.generate(
      64,
      (_) => List.generate(3, (_) => rand.nextInt(0x7fffffff)),
    );

    _zobristPlayerXor = rand.nextInt(0x7fffffff); // 手番情報用の乱数を生成
  }

  // パターン評価テーブルの初期化
  void _initPatternTable() {
    // すでに初期化済みなら終了
    if (_patternTableInitialized) {
      return;
    }

    // 3^10通りの全パターンを生成
    for (int i = 0; i < 59049; i++) {
      int score = 0; // 評価値
      int tmp = i; // パターン番号を保持
      List<int> p = List.filled(10, 0); // 10マス分の状態を格納

      // 10桁の3進数へ変換
      for (int j = 0; j < 10; j++) {
        p[j] = tmp % 3;
        tmp ~/= 3;
      }

      // 左端角の評価
      if (p[0] == 1) {
        score += 300;
      }

      if (p[0] == 2) {
        score -= 300;
      }

      // 右端角の評価
      if (p[7] == 1) {
        score += 300;
      }

      if (p[7] == 2) {
        score -= 300;
      }

      // 左角が空いている場合のXマス評価
      if (p[0] == 0) {
        if (p[8] == 1) {
          score -= 150;
        }

        if (p[8] == 2) {
          score += 150;
        }
      }

      // 右角が空いている場合のXマス評価
      if (p[7] == 0) {
        if (p[9] == 1) {
          score -= 150;
        }

        if (p[9] == 2) {
          score += 150;
        }
      }

      // 辺上の通常マス評価
      for (int j = 1; j < 7; j++) {
        if (p[j] == 1) {
          score += 20;
        }

        if (p[j] == 2) {
          score -= 20;
        }
      }

      _edgePatternTable[i] = score; // 計算した評価値を保存
    }

    _patternTableInitialized = true; // 初期化完了フラグ
  }

  // ゲームを初期状態へ戻す
  void reset() {
    board = List.generate(8, (_) => List.generate(8, (_) => 0)); // 8×8の空盤面を生成
    board[3][3] = 2; // 初期配置（白）
    board[3][4] = 1; // 初期配置（黒）
    board[4][3] = 1; // 初期配置（黒）
    board[4][4] = 2; // 初期配置（白）

    currentPlayer = 1; // 黒から開始
    passMessage = ""; // パスメッセージを初期化
    _transpositionTable.clear(); // 置換表をクリア

    // Killer Heuristicテーブルを初期化
    _killerMoves = List.generate(60, (_) => List.filled(2, null));
    // History Heuristicテーブルを初期化
    _historyTable = List.generate(8, (_) => List.filled(8, 0));

    _calculateFullHash(); // 現在盤面のハッシュ値を計算

    final List<int> roles = [1, 2]; // AI先手・後手をランダム決定

    roles.shuffle();

    aiPlayer = roles.first;
  }

  // 現在の盤面からハッシュ値を再計算
  void _calculateFullHash() {
    _currentHash = 0; // ハッシュ値初期化

    // 全マスを走査
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        int state = board[r][c]; // マスの状態取得

        _currentHash ^= _zobristTable[r * 8 + c][state]; // XOR演算でハッシュ生成
      }
    }

    // 黒番の場合は手番情報も反映
    if (currentPlayer == 1) {
      _currentHash ^= _zobristPlayerXor;
    }
  }

  // 相手プレイヤー番号を取得
  int getOpponent(int player) => player == 1 ? 2 : 1;

  // 指定座標が盤面内か判定
  bool _isInside(int r, int c) => r >= 0 && r < 8 && c >= 0 && c < 8;

  // 指定位置へ石を置けるか判定
  bool canPlaceStone(int row, int col, int player) {
    // すでに石がある場合は置けない
    if (board[row][col] != 0) {
      return false;
    }

    int opponent = getOpponent(player); // 相手プレイヤー取得

    // 8方向を探索
    for (var dir in _directions) {
      int r = row + dir[0];
      int c = col + dir[1];

      bool foundOpponent = false; // 相手石を見つけたか判定

      // 盤面外へ出るまで探索
      while (_isInside(r, c)) {
        // 相手石発見
        if (board[r][c] == opponent) {
          foundOpponent = true;
        }
        // 自分の石発見
        else if (board[r][c] == player) {
          // 間に相手石が存在するなら合法手
          if (foundOpponent) {
            return true;
          }

          break;
        }
        // 空マスなら探索終了
        else {
          break;
        }

        // 次マスへ移動
        r += dir[0];
        c += dir[1];
      }
    }

    return false; // どの方向にも挟めない場合
  }

  // 指定位置から石を反転する
  void flipStones(int row, int col, int player) {
    int opponent = getOpponent(player); // 相手プレイヤー取得

    // 8方向を探索
    for (var dir in _directions) {
      List<List<int>> stonesToFlip = []; // 反転候補の石を保存

      int r = row + dir[0];
      int c = col + dir[1];

      // 盤面内を探索
      while (_isInside(r, c)) {
        // 相手石なら候補へ追加
        if (board[r][c] == opponent) {
          stonesToFlip.add([r, c]);
        }
        // 自分の石に到達した場合
        else if (board[r][c] == player) {
          // 候補石をすべて反転
          for (var stone in stonesToFlip) {
            int idx = stone[0] * 8 + stone[1]; // ハッシュ値更新用インデックス
            _currentHash ^= _zobristTable[idx][opponent]; // 相手石状態を削除
            _currentHash ^= _zobristTable[idx][player]; // 自分石状態を追加
            board[stone[0]][stone[1]] = player; // 石を反転
          }
          break;
        }
        // 空マスなら終了
        else {
          break;
        }

        // 次マスへ移動
        r += dir[0];
        c += dir[1];
      }
    }
  }

  // 指定プレイヤーに合法手が存在するか判定
  bool hasValidMove(int player) {
    // 全マスを探索
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        // 合法手を発見
        if (canPlaceStone(r, c, player)) {
          return true;
        }
      }
    }

    // 合法手なし
    return false;
  }

  // 指定プレイヤーの石数を取得
  int countStones(int player) {
    return board.expand((row) => row).where((cell) => cell == player).length;
  }

  // 両プレイヤーが置けない場合ゲーム終了
  bool isGameOver() => !hasValidMove(1) && !hasValidMove(2);

  // 1ターン分の着手処理
  bool playTurn(int row, int col) {
    // 合法手でない場合
    if (!canPlaceStone(row, col, currentPlayer)) {
      return false;
    }

    int idx = row * 8 + col; // 配置位置のインデックス
    _currentHash ^= _zobristTable[idx][0]; // 空状態を削除
    _currentHash ^= _zobristTable[idx][currentPlayer]; // 現在プレイヤー状態を追加
    board[row][col] = currentPlayer; // 石配置
    flipStones(row, col, currentPlayer); // 石反転
    int nextPlayer = getOpponent(currentPlayer); // 次プレイヤー取得
    _currentHash ^= _zobristPlayerXor; // 手番変更をハッシュへ反映

    // 相手が着手可能な場合
    if (hasValidMove(nextPlayer)) {
      currentPlayer = nextPlayer;

      passMessage = "";
    }
    // 相手が着手できない場合
    else {
      // 現在プレイヤーが置ける場合
      if (hasValidMove(currentPlayer)) {
        // 手番変更を取り消す
        _currentHash ^= _zobristPlayerXor;

        passMessage = nextPlayer == 1 ? "黒は置けないためパス" : "白は置けないためパス";
      }
      // 両者とも置けない場合
      else {
        passMessage = "両者とも置けないためゲーム終了";
      }
    }

    return true;
  }

  // 指定プレイヤーの合法手一覧を生成
  List<List<int>> _generateValidMoves(int player) {
    List<List<int>> moves = [];

    // 全マスを探索
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        // 合法手を追加
        if (canPlaceStone(r, c, player)) {
          moves.add([r, c]);
        }
      }
    }

    return moves;
  }

  // 弱AI：合法手の中からランダムに選択
  List<int>? getWeakAiMove() {
    // 現在の手番プレイヤーの合法手一覧を取得
    List<List<int>> validMoves = _generateValidMoves(currentPlayer);

    // 合法手がなければパス
    if (validMoves.isEmpty) {
      return null;
    }

    validMoves.shuffle(); // 合法手をランダムに並び替え

    return validMoves.first; // 先頭の手を返す
  }

  // 強AI：盤面評価値が最も高いマスを選択
  List<int>? getStrongAiMove() {
    // 現在の合法手を取得
    List<List<int>> validMoves = _generateValidMoves(currentPlayer);

    // 合法手がなければパス
    if (validMoves.isEmpty) {
      return null;
    }

    List<int> best = validMoves.first; // とりあえず最初の手を候補にする
    int maxW = -999; // 最大評価値を保存する変数

    // 全ての合法手を調査
    for (var m in validMoves) {
      int w = _getStaticWeight(m[0], m[1]); // そのマスの静的評価値を取得

      // 現在の最大値より高ければ更新
      if (w > maxW) {
        maxW = w;
        best = m;
      }
    }

    return best; // 最も評価値の高い手を返す
  }

  // 🧠 最強AI：NegaScout探索を用いた高性能AI
  List<int>? getExpertAiMove() {
    // 現在の合法手を取得
    List<List<int>> validMoves = _generateValidMoves(currentPlayer);

    // 合法手がなければパス
    if (validMoves.isEmpty) {
      return null;
    }

    // 空きマス数を数える
    int emptyCells = board
        .expand((row) => row)
        .where((cell) => cell == 0)
        .length;

    bool isSolverMode = emptyCells <= 13; // 終盤なら完全読み切りモードへ移行
    int targetDepth = isSolverMode ? emptyCells : 10; // 終盤は残り手数まで、それ以外は深さ10で探索

    // 置換表が大きくなりすぎた場合は削除
    if (_transpositionTable.length > 150000) {
      _transpositionTable.clear();
    }

    List<int> bestMove = validMoves.first; // 最善手候補

    // 反復深化探索
    for (int d = 1; d <= targetDepth; d++) {
      // Alpha-Beta探索の初期値
      int alpha = -999999999;
      int beta = 999999999;

      List<int>? currentBestMove; // この深さでの最善手

      // ヒューリスティックを使って手を並び替える
      _sortMovesWithHeuristics(validMoves, d, currentPlayer);

      // 各合法手を探索
      for (int i = 0; i < validMoves.length; i++) {
        var move = validMoves[i];

        // 元の状態を保存
        int oldHash = _currentHash;
        int backupPlayer = currentPlayer;

        // マス番号へ変換
        int idx = move[0] * 8 + move[1];

        // Zobrist Hash更新
        _currentHash ^= _zobristTable[idx][0];
        _currentHash ^= _zobristTable[idx][currentPlayer];

        // 仮に着手
        board[move[0]][move[1]] = currentPlayer;

        // 石を反転し、反転した石を保存
        List<List<int>> flipped = _flipStonesAndReturn(
          move[0],
          move[1],
          currentPlayer,
        );

        // 次プレイヤーへ変更
        int nextPlayer = getOpponent(currentPlayer);

        // 手番ハッシュ更新
        _currentHash ^= _zobristPlayerXor;

        // 相手に合法手があれば手番交代
        if (hasValidMove(nextPlayer)) {
          currentPlayer = nextPlayer;
        }

        int score;

        // 最初の手は通常ウィンドウ探索
        if (i == 0) {
          score = -_negascout(d - 1, -beta, -alpha, 60 - d, isSolverMode);
        } else {
          // Null Window Search
          score = -_negascout(
            d - 1,
            -(alpha + 1),
            -alpha,
            60 - d,
            isSolverMode,
          );

          // Fail-Highなら再探索
          if (alpha < score && score < beta) {
            score = -_negascout(d - 1, -beta, -score, 60 - d, isSolverMode);
          }
        }

        // 反転した石を元に戻す
        for (var stone in flipped) {
          board[stone[0]][stone[1]] = getOpponent(backupPlayer);
        }

        // 着手した石を削除
        board[move[0]][move[1]] = 0;

        // 手番復元
        currentPlayer = backupPlayer;

        // ハッシュ値復元
        _currentHash = oldHash;

        // より良い評価値なら更新
        if (score > alpha) {
          alpha = score;
          currentBestMove = move;
        }
      }

      // この深さで最善手が見つかれば保存
      if (currentBestMove != null) {
        bestMove = currentBestMove;
      }

      // 勝ち確定レベルなら探索終了
      if (alpha > 800000) {
        break;
      }
    }

    // 最終的な最善手を返す
    return bestMove;
  }

  // 石を反転し、反転した石の位置一覧を返す
  List<List<int>> _flipStonesAndReturn(int row, int col, int player) {
    int opponent = getOpponent(player); // 相手プレイヤー番号を取得

    // 反転した石を全て保存するリスト
    List<List<int>> allFlipped = [];

    // 8方向について調査
    for (var dir in _directions) {
      // この方向で反転候補となる石を保存
      List<List<int>> stonesToFlip = [];

      // 隣接マスから探索開始
      int r = row + dir[0];
      int c = col + dir[1];

      // 盤面内である限り探索
      while (_isInside(r, c)) {
        // 相手石なら反転候補へ追加
        if (board[r][c] == opponent) {
          stonesToFlip.add([r, c]);

          // 自分の石に到達した場合
        } else if (board[r][c] == player) {
          // 間にある石を全て反転
          for (var stone in stonesToFlip) {
            // Zobrist Hash用インデックス
            int idx = stone[0] * 8 + stone[1];

            // ハッシュから相手石状態を除去
            _currentHash ^= _zobristTable[idx][opponent];

            // ハッシュへ自分石状態を追加
            _currentHash ^= _zobristTable[idx][player];

            // 石を反転
            board[stone[0]][stone[1]] = player;

            // 後で戻せるよう保存
            allFlipped.add(stone);
          }

          break;
        } else {
          // 空マスなら反転不可
          break;
        }

        // 次のマスへ移動
        r += dir[0];
        c += dir[1];
      }
    }

    return allFlipped; // 反転した石一覧を返す
  }

  // ⚡ NegaScout探索の本体
  int _negascout(
    int depth,
    int alpha,
    int beta,
    int ssDepth,
    bool isSolverMode,
  ) {
    int alphaOrig = alpha; // 元のAlpha値を保存

    // 置換表から同一局面を検索
    TTEntry? entry = _transpositionTable[_currentHash];

    // 十分な深さで探索済みなら結果を利用
    if (entry != null && entry.hash == _currentHash && entry.depth >= depth) {
      // 完全一致評価値
      if (entry.flag == 0) {
        return entry.score;

        // 下限値
      } else if (entry.flag == 1) {
        alpha = max(alpha, entry.score);

        // 上限値
      } else if (entry.flag == 2) {
        beta = min(beta, entry.score);
      }

      // 枝刈り成立
      if (alpha >= beta) {
        return entry.score;
      }
    }

    // 探索終了条件
    if (depth == 0 || isGameOver()) {
      // 終盤完全読みモード
      if (isSolverMode) {
        return (countStones(currentPlayer) -
                countStones(getOpponent(currentPlayer))) *
            10000;
      } else {
        // 評価関数を利用
        return _evaluateBoardPattern(currentPlayer);
      }
    }

    // 合法手一覧を取得
    List<List<int>> validMoves = _generateValidMoves(currentPlayer);

    // パス処理
    if (validMoves.isEmpty) {
      int nextPlayer = getOpponent(currentPlayer);

      // 両者とも打てない場合は終了
      if (!hasValidMove(nextPlayer)) {
        return (countStones(currentPlayer) - countStones(nextPlayer)) * 10000;
      }

      currentPlayer = nextPlayer; // 手番を交代して探索継続
      _currentHash ^= _zobristPlayerXor; // ハッシュ更新

      int score = -_negascout(depth, -beta, -alpha, ssDepth + 1, isSolverMode);

      // 状態復元
      _currentHash ^= _zobristPlayerXor;
      currentPlayer = getOpponent(nextPlayer);

      return score;
    }

    // 着手順序を最適化
    _sortNodeMoves(validMoves, ssDepth, entry);

    // この局面での最善手
    List<int>? bestMoveInThisNode;

    // 全合法手を探索
    for (int i = 0; i < validMoves.length; i++) {
      var move = validMoves[i];

      // 元状態保存
      int oldHash = _currentHash;
      int backupPlayer = currentPlayer;

      int idx = move[0] * 8 + move[1];

      // 着手によるハッシュ更新
      _currentHash ^= _zobristTable[idx][0];
      _currentHash ^= _zobristTable[idx][currentPlayer];

      // 仮着手
      board[move[0]][move[1]] = currentPlayer;

      // 石反転
      List<List<int>> flipped = _flipStonesAndReturn(
        move[0],
        move[1],
        currentPlayer,
      );

      // 相手手番へ変更
      int nextPlayer = getOpponent(currentPlayer);

      _currentHash ^= _zobristPlayerXor;

      if (hasValidMove(nextPlayer)) {
        currentPlayer = nextPlayer;
      }

      int score;

      // 最初の手は通常探索
      if (i == 0) {
        score = -_negascout(
          depth - 1,
          -beta,
          -alpha,
          ssDepth + 1,
          isSolverMode,
        );
      } else {
        // Null Window探索
        score = -_negascout(
          depth - 1,
          -(alpha + 1),
          -alpha,
          ssDepth + 1,
          isSolverMode,
        );

        // 評価値がウィンドウ内なら再探索
        if (alpha < score && score < beta) {
          score = -_negascout(
            depth - 1,
            -beta,
            -score,
            ssDepth + 1,
            isSolverMode,
          );
        }
      }

      // 反転石を元に戻す
      for (var stone in flipped) {
        board[stone[0]][stone[1]] = getOpponent(backupPlayer);
      }

      // 着手を取り消す
      board[move[0]][move[1]] = 0;

      // 手番復元
      currentPlayer = backupPlayer;

      // ハッシュ復元
      _currentHash = oldHash;

      // Beta Cut発生
      if (score >= beta) {
        // Killer Move登録
        if (ssDepth < 60 && _killerMoves[ssDepth][0] != move) {
          _killerMoves[ssDepth][1] = _killerMoves[ssDepth][0];
          _killerMoves[ssDepth][0] = move;
        }

        // History Heuristic更新
        _historyTable[move[0]][move[1]] += depth * depth;

        // 置換表へ保存
        _transpositionTable[_currentHash] = TTEntry(
          hash: _currentHash,
          score: beta,
          depth: depth,
          flag: 1,
          bestMove: move,
        );

        return beta;
      }

      // より良い手なら更新
      if (score > alpha) {
        alpha = score;
        bestMoveInThisNode = move;
      }
    }

    // 保存する評価種別を決定
    int flag = (alpha <= alphaOrig) ? 2 : 0;

    // 置換表へ保存
    _transpositionTable[_currentHash] = TTEntry(
      hash: _currentHash,
      score: alpha,
      depth: depth,
      flag: flag,
      bestMove: bestMoveInThisNode,
    );

    // 最終評価値を返す
    return alpha;
  }

  // 盤面評価関数
  int _evaluateBoardPattern(int player) {
    int opponent = getOpponent(player); // 相手プレイヤー番号取得
    int patternScore = 0; // パターン評価値

    // 上辺評価
    patternScore += _evaluateEdgePattern(0, 0, 0, 1, 1, 1, player);

    // 下辺評価
    patternScore += _evaluateEdgePattern(7, 0, 0, 1, 6, 1, player);

    // 左辺評価
    patternScore += _evaluateEdgePattern(0, 0, 1, 0, 1, 1, player);

    // 右辺評価
    patternScore += _evaluateEdgePattern(0, 7, 1, 0, 1, 6, player);

    // 安定石判定結果取得
    var stableMatrix = _calculateCompleteStableStones();

    int myStables = 0;
    int oppStables = 0;

    // 安定石数を集計
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (stableMatrix[r][c] == player) {
          myStables++;
        } else if (stableMatrix[r][c] == opponent) {
          oppStables++;
        }
      }
    }

    int myFrontier = 0;
    int oppFrontier = 0;

    // フロンティア石数を計算
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        // 空マスは評価対象外
        if (board[r][c] == 0) {
          continue;
        }

        bool isFrontier = false;

        // 周囲8方向を調べる
        for (var dir in _directions) {
          int nr = r + dir[0]; // 隣接マスの行
          int nc = c + dir[1]; // 隣接マスの列

          // 隣に空マスがあればフロンティア石
          if (_isInside(nr, nc) && board[nr][nc] == 0) {
            isFrontier = true;
            break;
          }
        }

        // フロンティア石を自分・相手別に集計
        if (isFrontier) {
          if (board[r][c] == player) {
            myFrontier++;
          } else {
            oppFrontier++;
          }
        }
      }
    }

    int myMobilityEstimate = 0;
    int oppMobilityEstimate = 0;

    // 行動可能性（可動性）を推定
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        // 空マスのみを対象に調査
        if (board[r][c] == 0) {
          // 空マスの周囲8方向を確認
          for (var d in _directions) {
            int nr = r + d[0]; // 隣接行
            int nc = c + d[1]; // 隣接列

            if (_isInside(nr, nc)) {
              // 相手石の隣に空マスがあるほど自分の手候補が増える
              if (board[nr][nc] == opponent) {
                myMobilityEstimate++;
              }

              // 自分石の隣に空マスがあるほど相手の手候補が増える
              if (board[nr][nc] == player) {
                oppMobilityEstimate++;
              }
            }
          }
        }
      }
    }

    // 可動性評価値を算出
    int mobilityScore = (myMobilityEstimate - oppMobilityEstimate) * 15;

    // フロンティア石評価値を算出（少ない方が有利）
    int frontierScore = (oppFrontier - myFrontier) * 18;

    // 安定石評価値を算出（多い方が有利）
    int stableScore = (myStables - oppStables) * 450;

    // 各評価値を合計して盤面評価値を返す
    return patternScore + mobilityScore + frontierScore + stableScore;
  }

  // 辺パターンの評価値を取得
  int _evaluateEdgePattern(
    int startR,
    int startC,
    int dr,
    int dc,
    int x1R,
    int x1C,
    int player,
  ) {
    int opponent = getOpponent(player); // 相手プレイヤー取得
    int index = 0; // パターンテーブル参照用インデックス

    // 辺の8マスを3進数としてエンコード
    for (int i = 0; i < 8; i++) {
      int cell = board[startR + i * dr][startC + i * dc];

      // 自分=1、相手=2、空=0 に変換
      int val = (cell == player) ? 1 : ((cell == opponent) ? 2 : 0);

      index += val * _pow3[i];
    }

    // Xスクエア1を追加
    int cellX1 = board[x1R][x1C];
    int valX1 = (cellX1 == player) ? 1 : ((cellX1 == opponent) ? 2 : 0);
    index += valX1 * _pow3[8];

    // Xスクエア2の座標を計算
    int x2R = x1R + (dr != 0 ? 5 * dr : 0);
    int x2C = x1C + (dc != 0 ? 5 * dc : 0);

    // Xスクエア2を追加
    int cellX2 = board[x2R][x2C];
    int valX2 = (cellX2 == player) ? 1 : ((cellX2 == opponent) ? 2 : 0);
    index += valX2 * _pow3[9];

    // 事前計算済みパターン評価値を返す
    return _edgePatternTable[index];
  }

  // 完全安定石を計算
  List<List<int>> _calculateCompleteStableStones() {
    // 安定石管理用の盤面
    List<List<int>> stable = List.generate(8, (_) => List.filled(8, 0));

    bool changed = true; // 安定石が増えたかを記録

    // 左上角が埋まっていれば安定石
    if (board[0][0] != 0) {
      stable[0][0] = board[0][0];
    }

    // 右上角が埋まっていれば安定石
    if (board[0][7] != 0) {
      stable[0][7] = board[0][7];
    }

    // 左下角が埋まっていれば安定石
    if (board[7][0] != 0) {
      stable[7][0] = board[7][0];
    }

    // 右下角が埋まっていれば安定石
    if (board[7][7] != 0) {
      stable[7][7] = board[7][7];
    }

    // 安定石が増えなくなるまで繰り返す
    while (changed) {
      changed = false;

      for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
          // 空マスまたは既に安定石ならスキップ
          if (board[r][c] == 0 || stable[r][c] != 0) {
            continue;
          }

          // 横方向の安定判定
          bool stableHorizontal = _isAxisStable(r, c, 0, 1, stable);

          // 縦方向の安定判定
          bool stableVertical = _isAxisStable(r, c, 1, 0, stable);

          // 斜め（＼）方向の安定判定
          bool stableDiag1 = _isAxisStable(r, c, 1, 1, stable);

          // 斜め（／）方向の安定判定
          bool stableDiag2 = _isAxisStable(r, c, 1, -1, stable);

          // 全方向で安定なら完全安定石とする
          if (stableHorizontal &&
              stableVertical &&
              stableDiag1 &&
              stableDiag2) {
            stable[r][c] = board[r][c];
            changed = true;
          }
        }
      }
    }

    // 完成した安定石情報を返す
    return stable;
  }

  // 指定方向において石が安定石か判定
  bool _isAxisStable(int r, int c, int dr, int dc, List<List<int>> stable) {
    int color = board[r][c]; // 対象石の色

    bool side1Stable = false;

    // 正方向の隣接マスを取得
    int nr = r + dr;
    int nc = c + dc;

    // 盤外なら端に接しているため安定
    if (!_isInside(nr, nc)) {
      side1Stable = true;

      // 同色の安定石に接している場合も安定
    } else if (stable[nr][nc] == color) {
      side1Stable = true;
    }

    bool side2Stable = false;

    // 逆方向の隣接マスを取得
    nr = r - dr;
    nc = c - dc;

    // 盤外なら端に接しているため安定
    if (!_isInside(nr, nc)) {
      side2Stable = true;

      // 同色の安定石に接している場合も安定
    } else if (stable[nr][nc] == color) {
      side2Stable = true;
    }

    // 両方向が安定している場合のみ安定石と判定
    return side1Stable && side2Stable;
  }

  // ルート探索時の手順序付け
  void _sortMovesWithHeuristics(List<List<int>> moves, int depth, int player) {
    // History Heuristicと静的位置評価を利用してソート
    moves.sort((a, b) {
      // 手Aの評価値
      int scoreA = _historyTable[a[0]][a[1]] + _getStaticWeight(a[0], a[1]);

      // 手Bの評価値
      int scoreB = _historyTable[b[0]][b[1]] + _getStaticWeight(b[0], b[1]);

      // 高評価の手を先頭へ配置
      return scoreB.compareTo(scoreA);
    });
  }

  // NegaScout探索中の手順序付け
  void _sortNodeMoves(List<List<int>> moves, int ssDepth, TTEntry? entry) {
    // 置換表から最善手候補を取得
    List<int>? ttMove = entry?.bestMove;

    // Killer Moveを取得
    List<int>? killer1 = ssDepth < 60 ? _killerMoves[ssDepth][0] : null;

    List<int>? killer2 = ssDepth < 60 ? _killerMoves[ssDepth][1] : null;

    moves.sort((a, b) {
      int rankA = 0;
      int rankB = 0;

      // 置換表の最善手を最優先
      if (ttMove != null && a[0] == ttMove[0] && a[1] == ttMove[1]) {
        rankA = 100000;
      }

      if (ttMove != null && b[0] == ttMove[0] && b[1] == ttMove[1]) {
        rankB = 100000;
      }

      // 第一Killer Moveを優先
      if (killer1 != null && a[0] == killer1[0] && a[1] == killer1[1]) {
        rankA = max(rankA, 50000);
      }

      if (killer1 != null && b[0] == killer1[0] && b[1] == killer1[1]) {
        rankB = max(rankB, 50000);
      }

      // 第二Killer Moveを優先
      if (killer2 != null && a[0] == killer2[0] && a[1] == killer2[1]) {
        rankA = max(rankA, 25000);
      }

      if (killer2 != null && b[0] == killer2[0] && b[1] == killer2[1]) {
        rankB = max(rankB, 25000);
      }

      // ランクが同じ場合はHistory Heuristicで比較
      if (rankA == rankB) {
        return _historyTable[b[0]][b[1]].compareTo(_historyTable[a[0]][a[1]]);
      }

      // 高ランク順に並べる
      return rankB.compareTo(rankA);
    });
  }

  // 盤面位置ごとの固定評価値を取得
  int _getStaticWeight(int r, int c) {
    // リバーシ定番の重みテーブル
    const List<List<int>> weightMap = [
      // 角は非常に高評価
      [200, -80, 20, 5, 5, 20, -80, 200],

      // 角の隣（X・Cマス）は危険なため低評価
      [-80, -120, -5, -5, -5, -5, -120, -80],

      [20, -5, 15, 3, 3, 15, -5, 20],

      [5, -5, 3, 3, 3, 3, -5, 5],

      [5, -5, 3, 3, 3, 3, -5, 5],

      [20, -5, 15, 3, 3, 15, -5, 20],

      [-80, -120, -5, -5, -5, -5, -120, -80],

      [200, -80, 20, 5, 5, 20, -80, 200],
    ];

    // 指定座標の評価値を返す
    return weightMap[r][c];
  }

  // 3進数エンコード用テーブル
  static const List<int> _pow3 = [1, 3, 9, 27, 81, 243, 729, 2187, 6561, 19683];
}


```]
