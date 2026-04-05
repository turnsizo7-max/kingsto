import 'dart:math';
import 'package:uuid/uuid.dart';

/// Game Types
enum GameType {
  connect4,
  ticTacToe,
  snake,
  tetris,
  chess,
  wordle,
}

/// Game State
class GameState {
  final String id;
  final GameType type;
  final String player1Id;
  final String? player2Id;
  final String? winnerId;
  final bool isComplete;
  final DateTime createdAt;
  final Map<String, dynamic> state;

  GameState({
    required this.id,
    required this.type,
    required this.player1Id,
    this.player2Id,
    this.winnerId,
    this.isComplete = false,
    required this.createdAt,
    required this.state,
  });
}

/// Games Service - Handles all game logic
class GamesService {
  final Uuid _uuid = const Uuid();
  
  // Active games storage
  final Map<String, GameState> _activeGames = {};

  // Create a new game
  GameState createGame(GameType type, String playerId) {
    final gameId = _uuid.v4();
    final state = _initializeGameState(type);
    
    final game = GameState(
      id: gameId,
      type: type,
      player1Id: playerId,
      createdAt: DateTime.now(),
      state: state,
    );
    
    _activeGames[gameId] = game;
    return game;
  }

  // Join a game
  GameState? joinGame(String gameId, String playerId) {
    final game = _activeGames[gameId];
    if (game == null || game.player2Id != null) return null;
    
    final updatedGame = GameState(
      id: game.id,
      type: game.type,
      player1Id: game.player1Id,
      player2Id: playerId,
      createdAt: game.createdAt,
      state: game.state,
    );
    
    _activeGames[gameId] = updatedGame;
    return updatedGame;
  }

  // Make a move
  GameState? makeMove(String gameId, String playerId, Map<String, dynamic> move) {
    final game = _activeGames[gameId];
    if (game == null || game.isComplete) return null;
    if (playerId != game.player1Id && playerId != game.player2Id) return null;
    
    final newState = _processMove(game.type, game.state, playerId, move);
    final winner = _checkWinner(game.type, newState, playerId);
    
    final updatedGame = GameState(
      id: game.id,
      type: game.type,
      player1Id: game.player1Id,
      player2Id: game.player2Id,
      winnerId: winner,
      isComplete: winner != null,
      createdAt: game.createdAt,
      state: newState,
    );
    
    _activeGames[gameId] = updatedGame;
    return updatedGame;
  }

  // Get game by ID
  GameState? getGame(String gameId) {
    return _activeGames[gameId];
  }

  // Get available games
  List<GameState> getAvailableGames(GameType type) {
    return _activeGames.values
        .where((g) => g.type == type && g.player2Id == null && !g.isComplete)
        .toList();
  }

  Map<String, dynamic> _initializeGameState(GameType type) {
    switch (type) {
      case GameType.connect4:
        return {
          'board': List.generate(6, (_) => List.filled(7, 0)),
          'currentPlayer': 1,
        };
      case GameType.ticTacToe:
        return {
          'board': List.filled(9, ''),
          'currentPlayer': 'X',
        };
      case GameType.snake:
        return {
          'snake': [[5, 5]],
          'food': [10, 10],
          'direction': 'right',
          'score': 0,
          'gameOver': false,
        };
      case GameType.tetris:
        return {
          'board': List.generate(20, (_) => List.filled(10, 0)),
          'currentPiece': null,
          'score': 0,
          'gameOver': false,
        };
      case GameType.chess:
        return _initializeChessBoard();
      case GameType.wordle:
        return {
          'word': _generateWordleWord(),
          'attempts': [],
          'currentAttempt': 0,
          'maxAttempts': 6,
          'gameOver': false,
        };
    }
  }

  Map<String, dynamic> _initializeChessBoard() {
    final board = List.generate(8, (i) => List.filled(8, ''));
    final pieces = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'];
    
    for (int j = 0; j < 8; j++) {
      board[0][j] = 'w${pieces[j]}';
      board[1][j] = 'wp';
      board[6][j] = 'bp';
      board[7][j] = 'b${pieces[j]}';
    }
    
    return {
      'board': board,
      'turn': 'white',
      'castling': {'white': true, 'black': true},
      'enPassant': null,
    };
  }

  String _generateWordleWord() {
    const words = [
      'WORLD', 'PHONE', 'GAMES', 'CODE', 'BUILD', 'WRITE', 
      'TEST', 'POWER', 'MAGIC', 'QUICK', 'BROWN', 'JUMPS'
    ];
    return words[Random().nextInt(words.length)];
  }

  Map<String, dynamic> _processMove(
    GameType type,
    Map<String, dynamic> state,
    String playerId,
    Map<String, dynamic> move,
  ) {
    switch (type) {
      case GameType.connect4:
        return _processConnect4Move(state, move);
      case GameType.ticTacToe:
        return _processTicTacToeMove(state, move);
      case GameType.snake:
        return _processSnakeMove(state, move);
      case GameType.tetris:
        return _processTetrisMove(state, move);
      case GameType.chess:
        return _processChessMove(state, move);
      case GameType.wordle:
        return _processWordleMove(state, move);
    }
  }

  Map<String, dynamic> _processConnect4Move(
    Map<String, dynamic> state,
    Map<String, dynamic> move,
  ) {
    final board = (state['board'] as List).map((r) => List<int>.from(r)).toList();
    final col = move['column'] as int;
    final player = state['currentPlayer'] as int;
    
    for (int row = 5; row >= 0; row--) {
      if (board[row][col] == 0) {
        board[row][col] = player;
        return {
          'board': board,
          'currentPlayer': player == 1 ? 2 : 1,
        };
      }
    }
    return state;
  }

  Map<String, dynamic> _processTicTacToeMove(
    Map<String, dynamic> state,
    Map<String, dynamic> move,
  ) {
    final board = List<String>.from(state['board']);
    final index = move['index'] as int;
    final player = state['currentPlayer'] as String;
    
    if (board[index].isEmpty) {
      board[index] = player;
      return {
        'board': board,
        'currentPlayer': player == 'X' ? 'O' : 'X',
      };
    }
    return state;
  }

  Map<String, dynamic> _processSnakeMove(
    Map<String, dynamic> state,
    Map<String, dynamic> move,
  ) {
    final snake = (state['snake'] as List).map((p) => List<int>.from(p)).toList();
    final food = List<int>.from(state['food'] as List);
    final direction = move['direction'] as String? ?? state['direction'] as String;
    final score = state['score'] as int;
    
    final head = List<int>.from(snake.first);
    switch (direction) {
      case 'up': head[1]--; break;
      case 'down': head[1]++; break;
      case 'left': head[0]--; break;
      case 'right': head[0]++; break;
    }
    
    var newSnake = [head, ...snake];
    var newScore = score;
    var newFood = List<int>.from(food);
    
    if (head[0] == food[0] && head[1] == food[1]) {
      newScore++;
      newFood = [Random().nextInt(20), Random().nextInt(20)];
    } else {
      newSnake.removeLast();
    }
    
    return {
      'snake': newSnake,
      'food': newFood,
      'direction': direction,
      'score': newScore,
      'gameOver': false,
    };
  }

  Map<String, dynamic> _processTetrisMove(
    Map<String, dynamic> state,
    Map<String, dynamic> move,
  ) {
    // Simplified tetris move processing
    return state;
  }

  Map<String, dynamic> _processChessMove(
    Map<String, dynamic> state,
    Map<String, dynamic> move,
  ) {
    final board = (state['board'] as List).map((r) => List<String>.from(r)).toList();
    final from = move['from'] as List;
    final to = move['to'] as List;
    
    board[to[0]][to[1]] = board[from[0]][from[1]];
    board[from[0]][from[1]] = '';
    
    return {
      'board': board,
      'turn': state['turn'] == 'white' ? 'black' : 'white',
    };
  }

  Map<String, dynamic> _processWordleMove(
    Map<String, dynamic> state,
    Map<String, dynamic> move,
  ) {
    final word = state['word'] as String;
    final attempts = (state['attempts'] as List).map((a) => a as String).toList();
    final guess = move['guess'] as String;
    
    attempts.add(guess);
    final gameOver = guess == word || attempts.length >= 6;
    
    return {
      'word': word,
      'attempts': attempts,
      'currentAttempt': attempts.length,
      'maxAttempts': 6,
      'gameOver': gameOver,
    };
  }

  String? _checkWinner(GameType type, Map<String, dynamic> state, String playerId) {
    switch (type) {
      case GameType.connect4:
        return _checkConnect4Winner(state);
      case GameType.ticTacToe:
        return _checkTicTacToeWinner(state);
      default:
        return null;
    }
  }

  String? _checkConnect4Winner(Map<String, dynamic> state) {
    final board = (state['board'] as List).map((r) => List<int>.from(r)).toList();
    final player = state['currentPlayer'] == 1 ? 2 : 1;
    
    // Check horizontal
    for (int r = 0; r < 6; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == player && board[r][c+1] == player &&
            board[r][c+2] == player && board[r][c+3] == player) {
          return player.toString();
        }
      }
    }
    
    // Check vertical
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 7; c++) {
        if (board[r][c] == player && board[r+1][c] == player &&
            board[r+2][c] == player && board[r+3][c] == player) {
          return player.toString();
        }
      }
    }
    return null;
  }

  String? _checkTicTacToeWinner(Map<String, dynamic> state) {
    final board = state['board'] as List;
    final lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // cols
      [0, 4, 8], [2, 4, 6], // diagonals
    ];
    
    for (final line in lines) {
      final a = board[line[0]] as String;
      final b = board[line[1]] as String;
      final c = board[line[2]] as String;
      if (a.isNotEmpty && a == b && b == c) {
        return a;
      }
    }
    return null;
  }
}