class Score {
  final int player1Score;
  final int player2Score;

  const Score({required this.player1Score, required this.player2Score});

  // Create initial score (0-0)
  factory Score.initial() {
    return const Score(player1Score: 0, player2Score: 0);
  }

  // Increment player 1 score
  Score incrementPlayer1() {
    return Score(player1Score: player1Score + 1, player2Score: player2Score);
  }

  // Increment player 2 score
  Score incrementPlayer2() {
    return Score(player1Score: player1Score, player2Score: player2Score + 1);
  }

  // Decrement player 1 score (with minimum of 0)
  Score decrementPlayer1() {
    return Score(
      player1Score: player1Score > 0 ? player1Score - 1 : 0,
      player2Score: player2Score,
    );
  }

  // Decrement player 2 score (with minimum of 0)
  Score decrementPlayer2() {
    return Score(
      player1Score: player1Score,
      player2Score: player2Score > 0 ? player2Score - 1 : 0,
    );
  }

  // For JSON serialization
  Map<String, dynamic> toJson() {
    return {'player1Score': player1Score, 'player2Score': player2Score};
  }

  // From JSON deserialization
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      player1Score: json['player1Score'] as int,
      player2Score: json['player2Score'] as int,
    );
  }
}

class Set {
  final String id;
  final Score score;
  final String status; // 'completed', 'in_progress', 'pending'
  final String? winner; // 'player1', 'player2', or null if not completed

  const Set({
    required this.id,
    required this.score,
    required this.status,
    this.winner,
  });

  // Create a new set
  factory Set.create() {
    return Set(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      score: Score.initial(),
      status: 'pending',
    );
  }

  // Start this set
  Set start() {
    return Set(id: id, score: score, status: 'in_progress', winner: null);
  }

  // Update score
  Set updateScore(Score newScore) {
    return Set(id: id, score: newScore, status: status, winner: winner);
  }

  // Complete this set
  Set complete({required String winner}) {
    return Set(id: id, score: score, status: 'completed', winner: winner);
  }

  // For JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score.toJson(),
      'status': status,
      'winner': winner,
    };
  }

  // From JSON deserialization
  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      id: json['id'] as String,
      score: Score.fromJson(json['score'] as Map<String, dynamic>),
      status: json['status'] as String,
      winner: json['winner'] as String?,
    );
  }
}

class Match {
  final String id;
  final String sportType;
  final String player1Name;
  final String player2Name;
  final List<Set> sets;
  final String status; // 'not_started', 'in_progress', 'completed'
  final int currentSetIndex;
  final String servingPlayer; // 'player1', 'player2'
  final List<String> gameHistory; // List of game points history
  final Map<String, String>
  gamePoints; // Current game points (e.g., '0', '15', '30', '40', 'Adv')

  // Get a list of tennis game point values
  static const List<String> tennisPoints = ['0', '15', '30', '40', 'Adv'];

  const Match({
    required this.id,
    required this.sportType,
    required this.player1Name,
    required this.player2Name,
    required this.sets,
    required this.status,
    required this.currentSetIndex,
    required this.servingPlayer,
    required this.gameHistory,
    required this.gamePoints,
  });

  // Create a new match
  factory Match.create({
    required String sportType,
    required String player1Name,
    required String player2Name,
    required int numberOfSets,
  }) {
    // Create sets based on the number requested
    final sets = List.generate(numberOfSets, (_) => Set.create());

    // Mark the first set as in progress
    if (sets.isNotEmpty) {
      sets[0] = sets[0].start();
    }

    return Match(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      sets: sets,
      status: 'in_progress',
      currentSetIndex: 0,
      servingPlayer: 'player1', // Default to player1 serving first
      gameHistory: [], // Initialize with empty history
      gamePoints: {'player1': '0', 'player2': '0'}, // Initialize game points
    );
  }

  // Get current set
  Set? get currentSet {
    if (currentSetIndex >= 0 && currentSetIndex < sets.length) {
      return sets[currentSetIndex];
    }
    return null;
  }

  // Update the current set
  Match updateCurrentSet(Set updatedSet) {
    if (currentSetIndex >= 0 && currentSetIndex < sets.length) {
      final updatedSets = List<Set>.from(sets);
      updatedSets[currentSetIndex] = updatedSet;

      return Match(
        id: id,
        sportType: sportType,
        player1Name: player1Name,
        player2Name: player2Name,
        sets: updatedSets,
        status: status,
        currentSetIndex: currentSetIndex,
        servingPlayer: servingPlayer,
        gameHistory: gameHistory,
        gamePoints: gamePoints,
      );
    }
    return this;
  }

  // Move to next set
  Match moveToNextSet() {
    if (currentSetIndex < sets.length - 1) {
      final updatedSets = List<Set>.from(sets);
      updatedSets[currentSetIndex + 1] = updatedSets[currentSetIndex + 1]
          .start();

      return Match(
        id: id,
        sportType: sportType,
        player1Name: player1Name,
        player2Name: player2Name,
        sets: updatedSets,
        status: status,
        currentSetIndex: currentSetIndex + 1,
        servingPlayer: servingPlayer,
        gameHistory: gameHistory,
        gamePoints: {
          'player1': '0',
          'player2': '0',
        }, // Reset game points for new set
      );
    }
    return this;
  }

  // Complete the match
  Match complete() {
    return Match(
      id: id,
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      sets: sets,
      status: 'completed',
      currentSetIndex: currentSetIndex,
      servingPlayer: servingPlayer,
      gameHistory: gameHistory,
      gamePoints: gamePoints,
    );
  }

  // Get set status description
  String getSetStatusDescription(int setIndex) {
    if (setIndex < 0 || setIndex >= sets.length) return '';

    final set = sets[setIndex];
    switch (set.status) {
      case 'completed':
        return set.winner == 'player1'
            ? '$player1Name won'
            : '$player2Name won';
      case 'in_progress':
        return 'In progress';
      default:
        return 'Not started';
    }
  }

  // Switch serving player
  Match switchServer() {
    final newServer = servingPlayer == 'player1' ? 'player2' : 'player1';
    return Match(
      id: id,
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      sets: sets,
      status: status,
      currentSetIndex: currentSetIndex,
      servingPlayer: newServer,
      gameHistory: gameHistory,
      gamePoints: gamePoints,
    );
  }

  // Update game points
  Match updateGamePoints(Map<String, String> newGamePoints) {
    return Match(
      id: id,
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      sets: sets,
      status: status,
      currentSetIndex: currentSetIndex,
      servingPlayer: servingPlayer,
      gameHistory: gameHistory,
      gamePoints: newGamePoints,
    );
  }

  // Add to game history
  Match addToGameHistory(String entry) {
    final updatedHistory = List<String>.from(gameHistory)..add(entry);
    return Match(
      id: id,
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      sets: sets,
      status: status,
      currentSetIndex: currentSetIndex,
      servingPlayer: servingPlayer,
      gameHistory: updatedHistory,
      gamePoints: gamePoints,
    );
  }

  // Reset game points
  Match resetGamePoints() {
    return Match(
      id: id,
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      sets: sets,
      status: status,
      currentSetIndex: currentSetIndex,
      servingPlayer: servingPlayer,
      gameHistory: gameHistory,
      gamePoints: {'player1': '0', 'player2': '0'},
    );
  }

  // For JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sportType': sportType,
      'player1Name': player1Name,
      'player2Name': player2Name,
      'sets': sets.map((set) => set.toJson()).toList(),
      'status': status,

      'currentSetIndex': currentSetIndex,
      'servingPlayer': servingPlayer,
      'gameHistory': gameHistory,
      'gamePoints': gamePoints,
    };
  }

  // From JSON deserialization
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      sportType: json['sportType'] as String,
      player1Name: json['player1Name'] as String,
      player2Name: json['player2Name'] as String,
      sets: (json['sets'] as List)
          .map((setJson) => Set.fromJson(setJson as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,

      currentSetIndex: json['currentSetIndex'] as int,
      servingPlayer: json['servingPlayer'] as String? ?? 'player1',
      gameHistory: (json['gameHistory'] as List?)?.cast<String>() ?? [],
      gamePoints:
          (json['gamePoints'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as String),
          ) ??
          {'player1': '0', 'player2': '0'},
    );
  }
}
