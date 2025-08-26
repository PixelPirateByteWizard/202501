import 'match_model.dart';
import '../utils/constants.dart';

class MatchScorerController {
  // Create a new match
  Match createMatch({
    required String sportType,
    required String player1Name,
    required String player2Name,
    required int numberOfSets,
  }) {
    return Match.create(
      sportType: sportType,
      player1Name: player1Name,
      player2Name: player2Name,
      numberOfSets: numberOfSets,
    );
  }

  // Update game points for tennis scoring
  Match updateTennisGamePoints(Match match, String player) {
    if (match.currentSet == null) return match;

    final currentPoints = Map<String, String>.from(match.gamePoints);
    final pointsList = Match.tennisPoints;

    // Get current point index for the player
    int currentIndex = pointsList.indexOf(currentPoints[player] ?? '0');

    // Handle deuce and advantage cases
    if (player == 'player1' &&
        currentPoints['player1'] == '40' &&
        currentPoints['player2'] == '40') {
      currentPoints['player1'] = 'Adv';
    } else if (player == 'player2' &&
        currentPoints['player1'] == '40' &&
        currentPoints['player2'] == '40') {
      currentPoints['player2'] = 'Adv';
    } else if (player == 'player1' && currentPoints['player2'] == 'Adv') {
      // If player2 had advantage and player1 scores, go back to deuce
      currentPoints['player2'] = '40';
    } else if (player == 'player2' && currentPoints['player1'] == 'Adv') {
      // If player1 had advantage and player2 scores, go back to deuce
      currentPoints['player1'] = '40';
    } else if (currentIndex < pointsList.length - 1) {
      // Normal progression through points
      currentPoints[player] = pointsList[currentIndex + 1];
    }

    // Check if game is won
    if ((currentPoints['player1'] == 'Adv' && player == 'player1') ||
        (currentPoints['player2'] == 'Adv' && player == 'player2') ||
        (currentPoints[player] == '40' &&
            currentPoints[player == 'player1' ? 'player2' : 'player1']! !=
                '40')) {
      // Game won, increment score
      Match updatedMatch = match;
      if (player == 'player1') {
        updatedMatch = incrementPlayer1Score(match);
      } else {
        updatedMatch = incrementPlayer2Score(match);
      }

      // Add to game history
      updatedMatch = updatedMatch.addToGameHistory(
        "${match.player1Name} ${currentPoints['player1']} - ${currentPoints['player2']} ${match.player2Name}",
      );

      // Reset game points
      updatedMatch = updatedMatch.resetGamePoints();

      // Switch server
      updatedMatch = updatedMatch.switchServer();

      return updatedMatch;
    }

    // Just update points
    return match.updateGamePoints(currentPoints);
  }

  // Increment score for player 1
  Match incrementPlayer1Score(Match match) {
    if (match.currentSet == null) return match;

    // Check if we should apply sport-specific rules
    if (match.sportType == 'Badminton' || match.sportType == 'Table Tennis') {
      // First increment the score
      final updatedScore = match.currentSet!.score.incrementPlayer1();
      final updatedSet = match.currentSet!.updateScore(updatedScore);
      Match updatedMatch = match.updateCurrentSet(updatedSet);

      // Check if this score meets winning conditions
      if (isWinningScore(updatedMatch, 'player1')) {
        // Complete the set with player1 as winner
        final completedSet = updatedMatch.currentSet!.complete(
          winner: 'player1',
        );
        updatedMatch = updatedMatch.updateCurrentSet(completedSet);

        // Move to next set if available
        if (updatedMatch.currentSetIndex < updatedMatch.sets.length - 1) {
          updatedMatch = updatedMatch.moveToNextSet();
        } else {
          // Match is complete
          updatedMatch = updatedMatch.complete();
        }
      }

      return updatedMatch;
    } else {
      // Default behavior for other sports
      final updatedSet = match.currentSet!.updateScore(
        match.currentSet!.score.incrementPlayer1(),
      );

      return match.updateCurrentSet(updatedSet);
    }
  }

  // Increment score for player 2
  Match incrementPlayer2Score(Match match) {
    if (match.currentSet == null) return match;

    // Check if we should apply sport-specific rules
    if (match.sportType == 'Badminton' || match.sportType == 'Table Tennis') {
      // First increment the score
      final updatedScore = match.currentSet!.score.incrementPlayer2();
      final updatedSet = match.currentSet!.updateScore(updatedScore);
      Match updatedMatch = match.updateCurrentSet(updatedSet);

      // Check if this score meets winning conditions
      if (isWinningScore(updatedMatch, 'player2')) {
        // Complete the set with player2 as winner
        final completedSet = updatedMatch.currentSet!.complete(
          winner: 'player2',
        );
        updatedMatch = updatedMatch.updateCurrentSet(completedSet);

        // Move to next set if available
        if (updatedMatch.currentSetIndex < updatedMatch.sets.length - 1) {
          updatedMatch = updatedMatch.moveToNextSet();
        } else {
          // Match is complete
          updatedMatch = updatedMatch.complete();
        }
      }

      return updatedMatch;
    } else {
      // Default behavior for other sports
      final updatedSet = match.currentSet!.updateScore(
        match.currentSet!.score.incrementPlayer2(),
      );

      return match.updateCurrentSet(updatedSet);
    }
  }

  // Decrement score for player 1
  Match decrementPlayer1Score(Match match) {
    if (match.currentSet == null) return match;

    final updatedSet = match.currentSet!.updateScore(
      match.currentSet!.score.decrementPlayer1(),
    );

    return match.updateCurrentSet(updatedSet);
  }

  // Decrement score for player 2
  Match decrementPlayer2Score(Match match) {
    if (match.currentSet == null) return match;

    final updatedSet = match.currentSet!.updateScore(
      match.currentSet!.score.decrementPlayer2(),
    );

    return match.updateCurrentSet(updatedSet);
  }

  // Complete the current set
  Match completeCurrentSet(Match match, {required String winner}) {
    if (match.currentSet == null) return match;

    final completedSet = match.currentSet!.complete(winner: winner);
    Match updatedMatch = match.updateCurrentSet(completedSet);

    // If there are more sets, move to the next one
    if (match.currentSetIndex < match.sets.length - 1) {
      updatedMatch = updatedMatch.moveToNextSet();
    } else {
      // If this was the last set, complete the match
      updatedMatch = updatedMatch.complete();
    }

    return updatedMatch;
  }

  // End the match
  Match endMatch(Match match) {
    return match.complete();
  }

  // Determine the winner of the current set based on scores
  String? determineSetWinner(Match match) {
    if (match.currentSet == null) return null;

    final score = match.currentSet!.score;

    // This is a simplified logic - real implementation would depend on the sport
    if (score.player1Score > score.player2Score) {
      return 'player1';
    } else if (score.player2Score > score.player1Score) {
      return 'player2';
    }

    return null; // Tie
  }

  // Get the number of sets won by each player
  Map<String, int> getSetWinCounts(Match match) {
    int player1Wins = 0;
    int player2Wins = 0;

    for (final set in match.sets) {
      if (set.winner == 'player1') {
        player1Wins++;
      } else if (set.winner == 'player2') {
        player2Wins++;
      }
    }

    return {'player1': player1Wins, 'player2': player2Wins};
  }

  // Check if score meets winning conditions based on sport rules
  bool isWinningScore(Match match, String player) {
    if (match.currentSet == null) return false;

    final sportRules = AppConstants.sportRules[match.sportType];
    if (sportRules == null) return false;

    final score = match.currentSet!.score;
    final player1Score = score.player1Score;
    final player2Score = score.player2Score;

    // Get the player's score and opponent's score
    final playerScore = player == 'player1' ? player1Score : player2Score;
    final opponentScore = player == 'player1' ? player2Score : player1Score;

    switch (match.sportType) {
      case 'Badminton':
        final winningScore = sportRules['winningScore'] as int;
        final minDifference = sportRules['minDifference'] as int;
        final maxScore = sportRules['maxScore'] as int;

        // Win by reaching max score
        if (playerScore == maxScore) return true;

        // Win by reaching winning score with minimum point difference
        if (playerScore >= winningScore &&
            (playerScore - opponentScore) >= minDifference) {
          return true;
        }
        return false;

      case 'Table Tennis':
        final winningScore = sportRules['winningScore'] as int;
        final minDifference = sportRules['minDifference'] as int;

        // Win by reaching winning score with minimum point difference
        if (playerScore >= winningScore &&
            (playerScore - opponentScore) >= minDifference) {
          return true;
        }
        return false;

      case 'Tennis':
        // Tennis scoring is handled separately with games and sets
        return false;

      default:
        return false;
    }
  }

  // Determine if the match is over (one player has won majority of sets)
  bool isMatchOver(Match match) {
    final winCounts = getSetWinCounts(match);
    final totalSets = match.sets.length;
    final majorityNeeded = (totalSets ~/ 2) + 1;

    return winCounts['player1']! >= majorityNeeded ||
        winCounts['player2']! >= majorityNeeded;
  }

  // Undo the last score change
  Match undoLastAction(Match match) {
    // If there's game history, we can undo the last game
    if (match.gameHistory.isNotEmpty) {
      // Create a new match with the last game history item removed
      final updatedHistory = List<String>.from(match.gameHistory);
      updatedHistory.removeLast();

      // This is a simplified undo - in a real app, you'd want to store more state
      // to properly restore the previous state
      return Match(
        id: match.id,
        sportType: match.sportType,
        player1Name: match.player1Name,
        player2Name: match.player2Name,
        sets: match.sets,
        status: match.status,
        currentSetIndex: match.currentSetIndex,
        servingPlayer: match.servingPlayer == 'player1'
            ? 'player2'
            : 'player1', // Toggle server back
        gameHistory: updatedHistory,
        gamePoints: match.gamePoints,
      );
    }
    return match;
  }

  // Switch the serving player
  Match switchServer(Match match) {
    return match.switchServer();
  }

  // Get the overall match winner
  String? getMatchWinner(Match match) {
    final winCounts = getSetWinCounts(match);

    if (winCounts['player1']! > winCounts['player2']!) {
      return 'player1';
    } else if (winCounts['player2']! > winCounts['player1']!) {
      return 'player2';
    }

    return null; // Tie
  }
}
