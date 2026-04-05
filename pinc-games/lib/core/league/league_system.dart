import 'package:uuid/uuid.dart';

/// League System - Manages player rankings and leagues
class Player {
  final String id;
  final String username;
  int rank;
  int points;
  int wins;
  int losses;
  String league; // Bronze, Silver, Gold, Platinum, Diamond, Champion

  Player({
    required this.id,
    required this.username,
    this.rank = 0,
    this.points = 0,
    this.wins = 0,
    this.losses = 0,
    this.league = 'Bronze',
  });
}

class LeagueMatch {
  final String id;
  final String player1Id;
  final String player2Id;
  final String gameType;
  final int wager;
  final String status; // pending, in_progress, completed
  final String? winnerId;
  final DateTime createdAt;

  LeagueMatch({
    required this.id,
    required this.player1Id,
    required this.player2Id,
    required this.gameType,
    this.wager = 0,
    this.status = 'pending',
    this.winnerId,
    required this.createdAt,
  });
}

class LeagueService {
  final Uuid _uuid = const Uuid();
  
  final Map<String, Player> _players = {};
  final List<LeagueMatch> _matches = [];

  static const List<String> leagues = [
    'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Champion'
  ];

  // Register a new player
  Player registerPlayer(String username) {
    final player = Player(
      id: _uuid.v4(),
      username: username,
      league: 'Bronze',
    );
    _players[player.id] = player;
    return player;
  }

  // Get player by ID
  Player? getPlayer(String playerId) {
    return _players[playerId];
  }

  // Get leaderboard
  List<Player> getLeaderboard({String? league, int limit = 50}) {
    var players = _players.values.toList();
    
    if (league != null) {
      players = players.where((p) => p.league == league).toList();
    }
    
    players.sort((a, b) => b.points.compareTo(a.points));
    return players.take(limit).toList();
  }

  // Create a match
  LeagueMatch createMatch({
    required String player1Id,
    required String player2Id,
    required String gameType,
    int wager = 0,
  }) {
    return LeagueMatch(
      id: _uuid.v4(),
      player1Id: player1Id,
      player2Id: player2Id,
      gameType: gameType,
      wager: wager,
      createdAt: DateTime.now(),
    );
  }

  // Complete a match
  void completeMatch(String matchId, String winnerId) {
    final matchIndex = _matches.indexWhere((m) => m.id == matchId);
    if (matchIndex == -1) return;
    
    final match = _matches[matchIndex];
    final winner = _players[winnerId];
    final loserId = match.player1Id == winnerId 
      ? match.player2Id 
      : match.player1Id;
    final loser = _players[loserId];
    
    if (winner != null && loser != null) {
      // Update winner
      winner.wins++;
      winner.points += 10 + (match.wager ~/ 10);
      _updateLeague(winner);
      
      // Update loser
      loser.losses++;
      loser.points = (loser.points - 5).clamp(0, 999999);
      _updateLeague(loser);
    }
  }

  void _updateLeague(Player player) {
    if (player.points >= 1000) {
      player.league = 'Champion';
      player.rank = 1;
    } else if (player.points >= 500) {
      player.league = 'Diamond';
      player.rank = 2;
    } else if (player.points >= 250) {
      player.league = 'Platinum';
      player.rank = 3;
    } else if (player.points >= 100) {
      player.league = 'Gold';
      player.rank = 4;
    } else if (player.points >= 50) {
      player.league = 'Silver';
      player.rank = 5;
    } else {
      player.league = 'Bronze';
      player.rank = 6;
    }
  }

  // Get matches for a player
  List<LeagueMatch> getPlayerMatches(String playerId) {
    return _matches.where(
      (m) => m.player1Id == playerId || m.player2Id == playerId
    ).toList();
  }

  // Get league statistics
  Map<String, int> getLeagueStats() {
    final stats = <String, int>{};
    for (final league in leagues) {
      stats[league] = _players.values.where((p) => p.league == league).length;
    }
    return stats;
  }
}