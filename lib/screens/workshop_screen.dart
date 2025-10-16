import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

import '../widgets/resource_grid.dart';
import '../widgets/workstation_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/quick_actions.dart';

import '../services/game_data_service.dart';
import '../models/resource.dart';
import '../models/workstation.dart';

class WorkshopScreen extends StatefulWidget {
  const WorkshopScreen({super.key});

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  final GameDataService _gameDataService = GameDataService();
  List<Resource> _resources = [];
  List<Workstation> _workstations = [];
  Map<String, dynamic> _gameProgress = {};
  bool _isLoading = true;
  late Timer _productionTimer;
  int _totalProduction = 0;
  int _efficiency = 85;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startProductionTimer();
  }

  @override
  void dispose() {
    _productionTimer.cancel();
    super.dispose();
  }

  void _startProductionTimer() {
    _productionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _simulateProduction();
    });
  }

  void _simulateProduction() {
    if (!mounted) return;

    setState(() {
      // Simulate resource production from active workstations
      for (var workstation in _workstations) {
        if (workstation.isBuilt &&
            workstation.status == WorkstationStatus.optimal) {
          _totalProduction += workstation.level;

          // Find and update output resource
          final resourceIndex = _resources.indexWhere(
            (r) => r.name == workstation.outputResource,
          );
          if (resourceIndex != -1) {
            _resources[resourceIndex] = _resources[resourceIndex].copyWith(
              amount: _resources[resourceIndex].amount + 1,
            );
          }
        }
      }

      // Randomly adjust efficiency
      if (DateTime.now().second % 10 == 0) {
        _efficiency = (85 + (DateTime.now().millisecond % 15)).clamp(70, 100);
      }
    });
  }

  Future<void> _loadData() async {
    final resources = await _gameDataService.getResources();
    final workstations = await _gameDataService.getWorkstations();
    final progress = await _gameDataService.getGameProgress();

    setState(() {
      _resources = resources;
      _workstations = workstations;
      _gameProgress = progress;
      _isLoading = false;
    });
  }

  void _onWorkstationTap(Workstation workstation) {
    if (workstation.isBuilt &&
        workstation.status != WorkstationStatus.offline) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.slateBlue,
          title: Text(
            workstation.name,
            style: const TextStyle(color: AppColors.vintageGold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input: ${workstation.inputResource}',
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
              const SizedBox(height: 8),
              Text(
                'Output: ${workstation.outputResource}',
                style: const TextStyle(color: AppColors.vintageGold),
              ),
              const SizedBox(height: 8),
              Text(
                'Efficiency: ${(workstation.efficiency * 100).toInt()}%',
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
              const SizedBox(height: 8),
              Text(
                'Level: ${workstation.level}',
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.vintageGold),
              ),
            ),
            if (workstation.status == WorkstationStatus.error)
              ElevatedButton(
                onPressed: () {
                  // Repair functionality
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Repair feature coming soon...'),
                      backgroundColor: AppColors.slateBlue,
                    ),
                  );
                },
                child: const Text('Repair'),
              ),
          ],
        ),
      );
    } else if (!workstation.isBuilt) {
      // Build new workstation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.slateBlue,
          title: const Text(
            'Build New Workstation',
            style: TextStyle(color: AppColors.vintageGold),
          ),
          content: const Text(
            'Choose a workstation type to build.',
            style: TextStyle(color: AppColors.lavenderWhite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.lavenderWhite),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Build feature coming soon...'),
                    backgroundColor: AppColors.slateBlue,
                  ),
                );
              },
              child: const Text('Build'),
            ),
          ],
        ),
      );
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
                              'Mechanical Workshop',
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
                              // Resources
                              GlassCard(
                                child: ResourceGrid(resources: _resources),
                              ),
                              const SizedBox(height: 16),

                              // Production Statistics
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Production Statistics',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            'Total Output',
                                            '$_totalProduction',
                                            Icons.trending_up,
                                            AppColors.statusOptimal,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Efficiency',
                                            '$_efficiency%',
                                            Icons.speed,
                                            _efficiency > 90
                                                ? AppColors.statusOptimal
                                                : _efficiency > 70
                                                ? AppColors.statusWarning
                                                : AppColors.statusError,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Active Stations',
                                            '${_workstations.where((w) => w.isBuilt && w.status == WorkstationStatus.optimal).length}',
                                            Icons.factory,
                                            AppColors.vintageGold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Production Rate',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.vintageGold,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomProgressBar(
                                      value: _efficiency / 100,
                                      color: _efficiency > 90
                                          ? AppColors.statusOptimal
                                          : _efficiency > 70
                                          ? AppColors.statusWarning
                                          : AppColors.statusError,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Production Line
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Production Line',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 180,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _workstations.length,
                                        itemBuilder: (context, index) {
                                          final workstation =
                                              _workstations[index];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right:
                                                  index <
                                                      _workstations.length - 1
                                                  ? 16
                                                  : 0,
                                            ),
                                            child: WorkstationCard(
                                              workstation: workstation,
                                              onTap: () => _onWorkstationTap(
                                                workstation,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Workshop Core
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Workshop Core',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),

                                    // Efficiency
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Efficiency',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        Text(
                                          '${(_gameProgress['workshopEfficiency'] * 100).toInt()}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.vintageGold,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    CustomProgressBar(
                                      value:
                                          _gameProgress['workshopEfficiency'] ??
                                          0.0,
                                      color: AppColors.vintageGold,
                                    ),
                                    const SizedBox(height: 16),

                                    // Power Output
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Power Output',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        Text(
                                          '${_gameProgress['powerOutput']}/${_gameProgress['maxPower']} MW',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.accentRose,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    CustomProgressBar(
                                      value:
                                          (_gameProgress['powerOutput'] ?? 0) /
                                          (_gameProgress['maxPower'] ?? 1),
                                      color: AppColors.accentRose,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Quick Actions
                              const QuickActions(),
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slateBlue.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.lavenderWhite,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
