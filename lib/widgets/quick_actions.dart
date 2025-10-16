import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Collect All',
                  Icons.inventory,
                  AppColors.statusOptimal,
                  () => _showActionDialog(
                    context,
                    'Collect All',
                    'Collected all available resources!',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Auto Craft',
                  Icons.auto_fix_high,
                  AppColors.vintageGold,
                  () => _showActionDialog(
                    context,
                    'Auto Craft',
                    'Auto-crafting enabled for optimal resources!',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Repair All',
                  Icons.build,
                  AppColors.statusWarning,
                  () => _showActionDialog(
                    context,
                    'Repair All',
                    'All workstations repaired and optimized!',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Speed Boost',
                  Icons.flash_on,
                  AppColors.accentRose,
                  () => _showActionDialog(
                    context,
                    'Speed Boost',
                    'Production speed increased for 5 minutes!',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, String action, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          action,
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.lavenderWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }
}
