import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'match_model.dart';
import 'match_scorer_controller.dart';
import '../widgets/sport_card.dart';

class MatchScorerScreen extends StatefulWidget {
  const MatchScorerScreen({super.key});

  @override
  State<MatchScorerScreen> createState() => _MatchScorerScreenState();
}

class _MatchScorerScreenState extends State<MatchScorerScreen>
    with SingleTickerProviderStateMixin {
  final MatchScorerController _controller = MatchScorerController();
  final TextEditingController _player1Controller = TextEditingController(
    text: 'Player 1',
  );
  final TextEditingController _player2Controller = TextEditingController(
    text: 'Player 2',
  );

  Match? _currentMatch;
  String _selectedSport = 'Tennis';
  late AnimationController _animationController;
  bool _isMatchSummaryVisible = false;

  final Map<String, String> _sportEmojis = {
    'Tennis': '🎾',
    'Badminton': '🏸',
    'Table Tennis': '🏓',
    'Basketball': '🏀',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _createNewMatch();
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _createNewMatch() {
    setState(() {
      _currentMatch = _controller.createMatch(
        sportType: _selectedSport,
        player1Name: _player1Controller.text,
        player2Name: _player2Controller.text,
        numberOfSets: _selectedSport == 'Tennis'
            ? 3
            : 5, // More sets for non-tennis games
      );
    });
  }

  void _incrementPlayer1Score() {
    if (_currentMatch == null) return;

    setState(() {
      // For tennis, use the tennis scoring system
      if (_selectedSport == 'Tennis') {
        _currentMatch = _controller.updateTennisGamePoints(
          _currentMatch!,
          'player1',
        );
      } else {
        _currentMatch = _controller.incrementPlayer1Score(_currentMatch!);
      }

      // Animate the score change
      _animateScoreChange();
    });
  }

  void _animateScoreChange() {
    _animationController.reset();
    _animationController.forward();
  }

  void _incrementPlayer2Score() {
    if (_currentMatch == null) return;

    setState(() {
      // For tennis, use the tennis scoring system
      if (_selectedSport == 'Tennis') {
        _currentMatch = _controller.updateTennisGamePoints(
          _currentMatch!,
          'player2',
        );
      } else {
        _currentMatch = _controller.incrementPlayer2Score(_currentMatch!);
      }

      // Animate the score change
      _animateScoreChange();
    });
  }

  void _decrementPlayer1Score() {
    if (_currentMatch == null) return;

    setState(() {
      _currentMatch = _controller.decrementPlayer1Score(_currentMatch!);
    });
  }

  void _decrementPlayer2Score() {
    if (_currentMatch == null) return;

    setState(() {
      _currentMatch = _controller.decrementPlayer2Score(_currentMatch!);
    });
  }

  void _endCurrentSet() {
    if (_currentMatch == null) return;

    final winner = _controller.determineSetWinner(_currentMatch!);
    if (winner != null) {
      setState(() {
        _currentMatch = _controller.completeCurrentSet(
          _currentMatch!,
          winner: winner,
        );

        // Check if match is over
        if (_controller.isMatchOver(_currentMatch!)) {
          _showMatchSummary();
        }
      });
    }
  }

  void _switchServer() {
    if (_currentMatch == null) return;

    setState(() {
      _currentMatch = _controller.switchServer(_currentMatch!);
    });
  }

  void _showMatchSummary() {
    setState(() {
      _isMatchSummaryVisible = true;
    });
  }

  void _hideMatchSummary() {
    setState(() {
      _isMatchSummaryVisible = false;
    });
  }

  String _getSportRuleSummary(String sport) {
    final rules = AppConstants.sportRules[sport];
    if (rules == null) return '';
    return rules['description'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside of text fields
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Text(
                          AppConstants.matchScorer,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.sports,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Sport selection
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppConstants.sportTypes.length,
                        itemBuilder: (context, index) {
                          final sport = AppConstants.sportTypes[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SportCard(
                              sportName: sport,
                              emoji: _sportEmojis[sport] ?? '🏆',
                              isActive: _selectedSport == sport,
                              onTap: () {
                                setState(() {
                                  _selectedSport = sport;
                                });
                                _createNewMatch();
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Match card
                    if (_currentMatch != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Players and score
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Player 1
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Player 1',
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _player1Controller,
                                          textAlign: TextAlign.center,
                                          maxLength: 15,
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                            counterText: '',
                                            hintText: 'Player 1 name',
                                          ),
                                          onChanged: (value) {
                                            _createNewMatch();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Score display
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Set ${_currentMatch!.currentSetIndex + 1}',
                                          style: TextStyle(
                                            color: theme
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.6),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Use a Flexible layout to avoid overflow
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Decrement P1
                                            IconButton(
                                              onPressed: _decrementPlayer1Score,
                                              icon: const Icon(Icons.remove),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    theme.colorScheme.primary,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),

                                            // Score display with flexible layout
                                            Flexible(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // P1 Score
                                                  Flexible(
                                                    child: Container(
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          _currentMatch!
                                                                  .currentSet
                                                                  ?.score
                                                                  .player1Score
                                                                  .toString() ??
                                                              '0',
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 42,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 2.0,
                                                        ),
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(
                                                        fontSize: 28,
                                                      ),
                                                    ),
                                                  ),

                                                  // P2 Score
                                                  Flexible(
                                                    child: Container(
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          _currentMatch!
                                                                  .currentSet
                                                                  ?.score
                                                                  .player2Score
                                                                  .toString() ??
                                                              '0',
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 42,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Decrement P2
                                            IconButton(
                                              onPressed: _decrementPlayer2Score,
                                              icon: const Icon(Icons.remove),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    theme.colorScheme.primary,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Increment buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Increment P1
                                            ElevatedButton(
                                              onPressed: _incrementPlayer1Score,
                                              style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                              ),
                                              child: const Icon(Icons.add),
                                            ),
                                            const SizedBox(width: 24),
                                            // Increment P2
                                            ElevatedButton(
                                              onPressed: _incrementPlayer2Score,
                                              style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                              ),
                                              child: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Player 2
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Player 2',
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _player2Controller,
                                          textAlign: TextAlign.center,
                                          maxLength: 15,
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                            counterText: '',
                                            hintText: 'Player 2 name',
                                          ),
                                          onChanged: (value) {
                                            _createNewMatch();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Match info
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // Current Game
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Current Game',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: theme
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _currentMatch!
                                                          .gamePoints['player1'] ??
                                                      '0',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppConstants.cosmicBlue,
                                                  ),
                                                ),
                                                const Text(
                                                  ' - ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  _currentMatch!
                                                          .gamePoints['player2'] ??
                                                      '0',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppConstants.cosmicBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Sport Rules
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Sport Rules',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: theme
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppConstants
                                                    .spaceIndigo600
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _getSportRuleSummary(
                                                  _selectedSport,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Serves
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Serves',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: theme
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: _switchServer,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppConstants
                                                      .nebulaPurple
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: AppConstants
                                                        .nebulaPurple,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  _currentMatch!
                                                              .servingPlayer ==
                                                          'player1'
                                                      ? _currentMatch!
                                                            .player1Name
                                                      : _currentMatch!
                                                            .player2Name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // End Set button
                                  ElevatedButton.icon(
                                    onPressed: _endCurrentSet,
                                    icon: const Icon(Icons.flag),
                                    label: const Text('End Set'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.secondary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Match history
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Match History',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _showMatchSummary,
                            icon: const Icon(Icons.summarize),
                            label: const Text('Summary'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _currentMatch!.sets.length,
                          itemBuilder: (context, index) {
                            final set = _currentMatch!.sets[index];
                            String statusText;
                            Color statusColor;

                            if (set.status == 'completed') {
                              statusText = 'Completed';
                              statusColor = AppConstants.stardustGold;
                            } else if (set.status == 'in_progress') {
                              statusText = 'Active';
                              statusColor = AppConstants.cosmicBlue;
                            } else {
                              statusText = 'Pending';
                              statusColor = Colors.grey;
                            }

                            String resultText = '';
                            if (set.status == 'completed' &&
                                set.winner != null) {
                              final winnerName = set.winner == 'player1'
                                  ? _currentMatch!.player1Name
                                  : _currentMatch!.player2Name;
                              resultText =
                                  '$winnerName won ${set.score.player1Score}-${set.score.player2Score}';
                            } else if (set.status == 'in_progress') {
                              resultText = 'In progress';
                            } else {
                              resultText = 'Not started';
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Set ${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          resultText,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: theme
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        // Match Summary Overlay
        if (_isMatchSummaryVisible && _currentMatch != null)
          _buildMatchSummaryOverlay(theme),
      ],
    );
  }

  Widget _buildMatchSummaryOverlay(ThemeData theme) {
    final winCounts = _controller.getSetWinCounts(_currentMatch!);
    final matchWinner = _controller.getMatchWinner(_currentMatch!);

    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppConstants.spaceIndigo800,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppConstants.cosmicBlue.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: AppConstants.cosmicBlue.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                'Match Summary',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Players and Score
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _currentMatch!.player1Name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: matchWinner == 'player1'
                                ? AppConstants.stardustGold
                                : AppConstants.spaceIndigo600,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              winCounts['player1'].toString(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: matchWinner == 'player1'
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'vs',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _currentMatch!.player2Name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: matchWinner == 'player2'
                                ? AppConstants.stardustGold
                                : AppConstants.spaceIndigo600,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              winCounts['player2'].toString(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: matchWinner == 'player2'
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Match details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.spaceIndigo700.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Sport', _currentMatch!.sportType),
                    const Divider(color: Colors.white24),
                    _buildSummaryRow(
                      'Sets Played',
                      _currentMatch!.currentSetIndex.toString(),
                    ),
                    if (matchWinner != null) ...[
                      const Divider(color: Colors.white24),
                      _buildSummaryRow(
                        'Winner',
                        matchWinner == 'player1'
                            ? _currentMatch!.player1Name
                            : _currentMatch!.player2Name,
                        isHighlighted: true,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Close button
              ElevatedButton(
                onPressed: _hideMatchSummary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.cosmicBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? AppConstants.stardustGold : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
