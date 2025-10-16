import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

import '../widgets/clue_item.dart';
import '../services/game_data_service.dart';
import '../models/clue.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final GameDataService _gameDataService = GameDataService();
  List<Clue> _clues = [];
  bool _isLoading = true;
  final List<String> _selectedClues = [];

  @override
  void initState() {
    super.initState();
    _loadClues();
  }

  Future<void> _loadClues() async {
    final clues = await _gameDataService.getClues();
    setState(() {
      _clues = clues;
      _isLoading = false;
    });
  }

  void _onClueSelected(String clueId) {
    setState(() {
      if (_selectedClues.contains(clueId)) {
        _selectedClues.remove(clueId);
      } else if (_selectedClues.length < 2) {
        _selectedClues.add(clueId);
      }
    });
  }

  void _analyzeConnection() {
    if (_selectedClues.length == 2) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.slateBlue,
          title: const Text(
            'Analysis Result',
            style: TextStyle(color: AppColors.vintageGold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Analyzing connection between selected clues...',
                style: TextStyle(color: AppColors.lavenderWhite),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: AppColors.vintageGold),
              const SizedBox(height: 16),
              const Text(
                'Connection found! New blueprint unlocked.',
                style: TextStyle(color: AppColors.statusOptimal),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedClues.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New blueprint added to workshop!'),
                    backgroundColor: AppColors.statusOptimal,
                  ),
                );
              },
              child: const Text('Collect Reward'),
            ),
          ],
        ),
      );
    }
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return 'Today';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vintageGold),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.lavenderWhite,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'The Archive',
                              style: Theme.of(context).textTheme.displaySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recent Clues
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recent Clues',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _clues.length,
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                            color: AppColors.glassBorder,
                                            height: 1,
                                          ),
                                      itemBuilder: (context, index) {
                                        final clue = _clues[index];
                                        return ClueItem(
                                          clue: clue,
                                          timeAgo: _getTimeAgo(
                                            clue.acquiredDate,
                                          ),
                                          isSelected: _selectedClues.contains(
                                            clue.id,
                                          ),
                                          onTap: () => _onClueSelected(clue.id),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Truth Table
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Truth Table',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Connect related clues to uncover hidden truths and unlock new blueprints.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 16),

                                    // Connection Area
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.slateBlue,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.glassBorder,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildConnectionSlot(0),
                                              _buildConnectionSlot(1),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed:
                                                _selectedClues.length == 2
                                                ? _analyzeConnection
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  _selectedClues.length == 2
                                                  ? AppColors.vintageGold
                                                  : AppColors.slateBlue,
                                            ),
                                            child: const Text(
                                              'Analyze Connection',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildConnectionSlot(int index) {
    final hasClue = index < _selectedClues.length;
    final clue = hasClue
        ? _clues.firstWhere((c) => c.id == _selectedClues[index])
        : null;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasClue ? AppColors.vintageGold : AppColors.glassBorder,
          width: 2,
          style: hasClue ? BorderStyle.solid : BorderStyle.solid,
        ),
        color: hasClue
            ? AppColors.vintageGold.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: hasClue
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(clue!.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  clue.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.vintageGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : const Icon(Icons.add, color: AppColors.glassBorder, size: 32),
    );
  }
}
