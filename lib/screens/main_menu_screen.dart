import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';


import 'workshop_screen.dart';
import 'archive_screen.dart';
import 'enhanced_map_screen.dart';
import 'settings_screen.dart';
import 'quick_craft_screen.dart';
import 'truth_table_screen.dart';
import 'achievements_screen.dart';
import 'goals_screen.dart';
import 'progress_dashboard_screen.dart';
import 'daily_quests_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            'Main Menu',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () =>
                                _navigateToScreen(const ProgressDashboardScreen()),
                            icon: const Icon(
                              Icons.analytics,
                              color: AppColors.vintageGold,
                              size: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _navigateToScreen(const GoalsScreen()),
                            icon: const Icon(
                              Icons.flag,
                              color: AppColors.vintageGold,
                              size: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _navigateToScreen(const AchievementsScreen()),
                            icon: const Icon(
                              Icons.emoji_events,
                              color: AppColors.vintageGold,
                              size: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _navigateToScreen(const SettingsScreen()),
                            icon: const Icon(
                              Icons.settings,
                              color: AppColors.vintageGold,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose your destination',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Main Menu Cards
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Workshop Card
                              GlassCard(
                                onTap: () =>
                                    _navigateToScreen(const WorkshopScreen()),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.vintageGold
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.precision_manufacturing,
                                            color: AppColors.vintageGold,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Mechanical Workshop',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineSmall,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Build and upgrade workstations',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .lavenderWhite
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.lavenderWhite,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem('247', 'Gears'),
                                        _buildStatItem('89', 'Energy'),
                                        _buildStatItem('78%', 'Efficiency'),
                                        _buildStatItem('4', 'Stations'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Archive Card
                              GlassCard(
                                onTap: () =>
                                    _navigateToScreen(const ArchiveScreen()),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.vintageGold
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.archive,
                                            color: AppColors.vintageGold,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Secret Archive',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineSmall,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Collect and analyze clues',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .lavenderWhite
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.lavenderWhite,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem('15', 'Clues'),
                                        _buildStatItem(
                                          '2',
                                          'New',
                                          color: AppColors.accentRose,
                                        ),
                                        _buildStatItem('73%', 'Analyzed'),
                                        _buildStatItem('8', 'Theories'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // World Map Card
                              GlassCard(
                                onTap: () =>
                                    _navigateToScreen(const EnhancedMapScreen()),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.vintageGold
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.map,
                                            color: AppColors.vintageGold,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Interactive World Map',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineSmall,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Explore with AI-generated stories',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .lavenderWhite
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.lavenderWhite,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem('3', 'Maps'),
                                        _buildStatItem(
                                          '12',
                                          'Locations',
                                          color: AppColors.statusOptimal,
                                        ),
                                        _buildStatItem('AI', 'Stories'),
                                        _buildStatItem('∞', 'Adventures'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Daily Quests Card
                              GlassCard(
                                onTap: () =>
                                    _navigateToScreen(const DailyQuestsScreen()),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.accentRose
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.assignment,
                                            color: AppColors.accentRose,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Daily Quests',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineSmall,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Complete daily challenges',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .lavenderWhite
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.lavenderWhite,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem('3', 'Today'),
                                        _buildStatItem(
                                          'NEW',
                                          'Rewards',
                                          color: AppColors.accentRose,
                                        ),
                                        _buildStatItem('Daily', 'Reset'),
                                        _buildStatItem('∞', 'XP'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Quick Actions
                              Row(
                                children: [
                                  Expanded(
                                    child: GlassCard(
                                      onTap: () => _navigateToScreen(
                                        const QuickCraftScreen(),
                                      ),
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.build_circle,
                                            color: AppColors.vintageGold,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Quick Craft',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GlassCard(
                                      onTap: () => _navigateToScreen(
                                        const TruthTableScreen(),
                                      ),
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.table_chart,
                                            color: AppColors.vintageGold,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Truth Table',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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

  Widget _buildStatItem(String value, String label, {Color? color}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color ?? AppColors.vintageGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
