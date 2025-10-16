import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/game_data_service.dart';

class TruthTableScreen extends StatefulWidget {
  const TruthTableScreen({super.key});

  @override
  State<TruthTableScreen> createState() => _TruthTableScreenState();
}

class _TruthTableScreenState extends State<TruthTableScreen> {
  final GameDataService _gameDataService = GameDataService();
  List<TruthEntry> _truthEntries = [];

  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadTruthData();
  }

  Future<void> _loadTruthData() async {
    // Load discovered clues and create truth entries
    final clues = await _gameDataService.getClues();
    
    setState(() {
      _truthEntries = _generateTruthEntries(clues);

      _isLoading = false;
    });
  }

  List<TruthEntry> _generateTruthEntries(dynamic clues) {
    return [
      TruthEntry(
        id: 'clockwork_conspiracy',
        statement: 'The Clockwork Guild controls the city\'s power grid',
        evidence: ['fathers_journal_1', 'city_district_map'],
        truthValue: TruthValue.likely,
        category: 'Conspiracy',
        confidence: 0.75,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TruthEntry(
        id: 'automaton_rebellion',
        statement: 'Automatons are developing consciousness',
        evidence: ['strange_key', 'incomplete_blueprint'],
        truthValue: TruthValue.unknown,
        category: 'Technology',
        confidence: 0.45,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      TruthEntry(
        id: 'father_alive',
        statement: 'Father is still alive somewhere in the city',
        evidence: ['fathers_journal_1'],
        truthValue: TruthValue.possible,
        category: 'Personal',
        confidence: 0.30,
        lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      ),
      TruthEntry(
        id: 'energy_source',
        statement: 'The city\'s energy comes from a hidden source',
        evidence: ['city_district_map', 'incomplete_blueprint'],
        truthValue: TruthValue.likely,
        category: 'Technology',
        confidence: 0.80,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      TruthEntry(
        id: 'guild_infiltration',
        statement: 'The workshop has been infiltrated by Guild agents',
        evidence: ['strange_key'],
        truthValue: TruthValue.unlikely,
        category: 'Conspiracy',
        confidence: 0.25,
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }



  void _updateTruthValue(TruthEntry entry, TruthValue newValue) {
    setState(() {
      final index = _truthEntries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _truthEntries[index] = entry.copyWith(
          truthValue: newValue,
          lastUpdated: DateTime.now(),
        );
      }
    });
  }

  void _showEntryDetails(TruthEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          'Truth Analysis',
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.statement,
                style: const TextStyle(
                  color: AppColors.lavenderWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Current Assessment: ${entry.truthValue.name.toUpperCase()}',
                style: TextStyle(
                  color: _getTruthColor(entry.truthValue),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Confidence: ${(entry.confidence * 100).toInt()}%',
                style: const TextStyle(color: AppColors.vintageGold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Supporting Evidence:',
                style: TextStyle(
                  color: AppColors.vintageGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...entry.evidence.map(
                (evidence) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    '• ${evidence.replaceAll('_', ' ').toUpperCase()}',
                    style: const TextStyle(color: AppColors.lavenderWhite),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Update Assessment:',
                style: TextStyle(
                  color: AppColors.vintageGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TruthValue.values.map((value) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _updateTruthValue(entry, value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: entry.truthValue == value
                          ? AppColors.vintageGold
                          : AppColors.deepNavy,
                      foregroundColor: entry.truthValue == value
                          ? AppColors.deepNavy
                          : AppColors.lavenderWhite,
                    ),
                    child: Text(value.name.toUpperCase()),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTruthColor(TruthValue value) {
    switch (value) {
      case TruthValue.confirmed:
        return AppColors.statusOptimal;
      case TruthValue.likely:
        return AppColors.vintageGold;
      case TruthValue.possible:
        return AppColors.statusWarning;
      case TruthValue.unlikely:
        return AppColors.accentRose;
      case TruthValue.disproven:
        return AppColors.statusError;
      case TruthValue.unknown:
        return AppColors.lavenderWhite;
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

    final categories = ['All', ..._truthEntries.map((e) => e.category).toSet()];
    final filteredEntries = _selectedCategory == 'All'
        ? _truthEntries
        : _truthEntries.where((e) => e.category == _selectedCategory).toList();

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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                        'Truth Table',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Category Filter
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter by Category',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            backgroundColor: AppColors.deepNavy,
                            selectedColor: AppColors.vintageGold,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.deepNavy
                                  : AppColors.lavenderWhite,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Truth Entries
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) {
                    final entry = filteredEntries[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () => _showEntryDetails(entry),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getTruthColor(entry.truthValue),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.statement,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getTruthColor(entry.truthValue).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getTruthColor(entry.truthValue),
                                    ),
                                  ),
                                  child: Text(
                                    entry.truthValue.name.toUpperCase(),
                                    style: TextStyle(
                                      color: _getTruthColor(entry.truthValue),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  size: 14,
                                  color: AppColors.vintageGold.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  entry.category,
                                  style: TextStyle(
                                    color: AppColors.vintageGold.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.psychology,
                                  size: 14,
                                  color: AppColors.vintageGold.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Confidence: ${(entry.confidence * 100).toInt()}%',
                                  style: TextStyle(
                                    color: AppColors.vintageGold.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 14,
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${entry.evidence.length} evidence(s)',
                                  style: TextStyle(
                                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Updated ${_formatTimeAgo(entry.lastUpdated)}',
                                  style: TextStyle(
                                    color: AppColors.lavenderWhite.withValues(alpha: 0.5),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}

enum TruthValue { confirmed, likely, possible, unlikely, disproven, unknown }

class TruthEntry {
  final String id;
  final String statement;
  final List<String> evidence;
  final TruthValue truthValue;
  final String category;
  final double confidence;
  final DateTime lastUpdated;

  const TruthEntry({
    required this.id,
    required this.statement,
    required this.evidence,
    required this.truthValue,
    required this.category,
    required this.confidence,
    required this.lastUpdated,
  });

  TruthEntry copyWith({
    String? id,
    String? statement,
    List<String>? evidence,
    TruthValue? truthValue,
    String? category,
    double? confidence,
    DateTime? lastUpdated,
  }) {
    return TruthEntry(
      id: id ?? this.id,
      statement: statement ?? this.statement,
      evidence: evidence ?? this.evidence,
      truthValue: truthValue ?? this.truthValue,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

enum ConnectionStrength { weak, medium, strong }

class ClueConnection {
  final String from;
  final String to;
  final ConnectionStrength strength;
  final String type;

  const ClueConnection({
    required this.from,
    required this.to,
    required this.strength,
    required this.type,
  });
}