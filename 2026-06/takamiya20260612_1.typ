#import "@preview/codelst:2.0.2": sourcecode

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
== リバーシAI
#sourcecode[```dart

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

```]

#sourcecode[```dart
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
```]

#pagebreak()

#sourcecode[```dart
  // 最強AI：NegaScout探索を用いた高性能AI
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
= 今後の予定
- 使用するプログラムの改良
