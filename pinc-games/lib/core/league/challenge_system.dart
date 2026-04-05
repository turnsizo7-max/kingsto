import 'package:uuid/uuid.dart';

/// Challenge and Wager System
enum ChallengeStatus {
  pending,
  accepted,
  declined,
  completed,
  cancelled,
}

class Challenge {
  final String id;
  final String challengerId;
  final String challengedId;
  final String gameType;
  final int wagerAmount;
  final ChallengeStatus status;
  final String? winnerId;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.challengerId,
    required this.challengedId,
    required this.gameType,
    required this.wagerAmount,
    this.status = ChallengeStatus.pending,
    this.winnerId,
    required this.createdAt,
  });
}

class ExternalGameLink {
  final String platform; // PSN, Xbox, Steam
  final String username;
  final String? friendCode;
  final DateTime linkedAt;
}

class ChallengeService {
  final Uuid _uuid = const Uuid();
  
  final Map<String, Challenge> _challenges = {};
  final Map<String, ExternalGameLink> _externalLinks = {};

  // Create a challenge
  Challenge createChallenge({
    required String challengerId,
    required String challengedId,
    required String gameType,
    required int wagerAmount,
  }) {
    final challenge = Challenge(
      id: _uuid.v4(),
      challengerId: challengerId,
      challengedId: challengedId,
      gameType: gameType,
      wagerAmount: wagerAmount,
      createdAt: DateTime.now(),
    );
    
    _challenges[challenge.id] = challenge;
    return challenge;
  }

  // Accept a challenge
  Challenge? acceptChallenge(String challengeId) {
    final challenge = _challenges[challengeId];
    if (challenge == null || challenge.status != ChallengeStatus.pending) {
      return null;
    }
    
    final updated = Challenge(
      id: challenge.id,
      challengerId: challenge.challengerId,
      challengedId: challenge.challengedId,
      gameType: challenge.gameType,
      wagerAmount: challenge.wagerAmount,
      status: ChallengeStatus.accepted,
      createdAt: challenge.createdAt,
    );
    
    _challenges[challengeId] = updated;
    return updated;
  }

  // Decline a challenge
  Challenge? declineChallenge(String challengeId) {
    final challenge = _challenges[challengeId];
    if (challenge == null) return null;
    
    final updated = Challenge(
      id: challenge.id,
      challengerId: challenge.challengerId,
      challengedId: challenge.challengedId,
      gameType: challenge.gameType,
      wagerAmount: challenge.wagerAmount,
      status: ChallengeStatus.declined,
      createdAt: challenge.createdAt,
    );
    
    _challenges[challengeId] = updated;
    return updated;
  }

  // Complete a challenge
  Challenge? completeChallenge(String challengeId, String winnerId) {
    final challenge = _challenges[challengeId];
    if (challenge == null || challenge.status != ChallengeStatus.accepted) {
      return null;
    }
    
    final updated = Challenge(
      id: challenge.id,
      challengerId: challenge.challengerId,
      challengedId: challenge.challengedId,
      gameType: challenge.gameType,
      wagerAmount: challenge.wagerAmount,
      status: ChallengeStatus.completed,
      winnerId: winnerId,
      createdAt: challenge.createdAt,
    );
    
    _challenges[challengeId] = updated;
    return updated;
  }

  // Get challenges for a player
  List<Challenge> getPlayerChallenges(String playerId) {
    return _challenges.values.where(
      (c) => c.challengerId == playerId || c.challengedId == playerId
    ).toList();
  }

  // Get pending challenges
  List<Challenge> getPendingChallenges(String playerId) {
    return _challenges.values.where(
      (c) => (c.challengedId == playerId || c.challengerId == playerId) &&
             c.status == ChallengeStatus.pending
    ).toList();
  }

  // Link external game account
  void linkExternalAccount({
    required String playerId,
    required String platform,
    required String username,
    String? friendCode,
  }) {
    final key = '$playerId-$platform';
    _externalLinks[key] = ExternalGameLink(
      platform: platform,
      username: username,
      friendCode: friendCode,
      linkedAt: DateTime.now(),
    );
  }

  // Get external account links
  List<ExternalGameLink> getExternalLinks(String playerId) {
    return _externalLinks.entries
        .where((e) => e.key.startsWith(playerId))
        .map((e) => e.value)
        .toList();
  }

  // Get available opponents (players with pending challenges)
  List<String> getAvailableOpponents(String playerId) {
    return _challenges.values
        .where((c) => c.challengedId == playerId && c.status == ChallengeStatus.pending)
        .map((c) => c.challengerId)
        .toList();
  }
}